---
title: Objective-C Runtime 源码学习
date: 2021-09-06 16:46:37
tags:
---



# Objective-C Runtime源码学习

## 项目结构

-   `Public Headers`
-   `Private Headers`
-   `Project Headers`
-   `Source` ( Implementation )
-   `Obsolete Headers`
-   `Obsolete Source`



### Runtime的三种调用方式：

1、`runtime api` --> (class_、objc_、object_)
2、`NSObject api` --> (isKindOfClass、isMemberOfClass)
3、OC上层方法 -->（@selector）



## 重点概念及数据结构

1.   objc_object

     >   Represents an instance of a class.

     >   objc.h

     ```c
     struct objc_object {
         Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
     };
     ```

     

2.   id

     >   A pointer to an instance of a class.

     >   objc.h

     ```c
     typedef struct objc_object *id;
     ```



3.   objc_class

     

     >   An opaque type that represents an Objective-C class.

     >   objc.h

     ```c
     typedef struct objc_class *Class;
     ```

     

     >   runtime.h

     ```c
     struct objc_class {
         Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
     
     #if !__OBJC2__
         Class _Nullable super_class                              OBJC2_UNAVAILABLE;
         const char * _Nonnull name                               OBJC2_UNAVAILABLE;
         long version                                             OBJC2_UNAVAILABLE;
         long info                                                OBJC2_UNAVAILABLE;
         long instance_size                                       OBJC2_UNAVAILABLE;
         struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
         struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
         struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
         struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
     #endif
     
     } OBJC2_UNAVAILABLE;
     /* Use `Class` instead of `struct objc_class *` */
     ```

     



## Objc环境初始化



1.   `objc-os.mm` L.922 `void _objc_init(void)`

```objective-c
void _objc_init(void)
{
    static bool initialized = false;
    if (initialized) return;
    initialized = true;
    
    // fixme defer initialization until an objc-using image is found?
    environ_init();
    tls_init();
    static_init();
    runtime_init();
    exception_init();
#if __OBJC2__
    cache_t::init();
#endif
    _imp_implementationWithBlock_init();

    _dyld_objc_notify_register(&map_images, load_images, unmap_image);

#if __OBJC2__
    didCallDyldNotifyRegister = true;
#endif
}
```



2.   `environ_init()`

     `objc-runtime.mm` L.367

```objective-c
void environ_init(void) 
{
    if (issetugid()) {
        // All environment variables are silently ignored when setuid or setgid
        // This includes OBJC_HELP and OBJC_PRINT_OPTIONS themselves.
        return;
    } 

    // Turn off autorelease LRU coalescing by default for apps linked against
    // older SDKs. LRU coalescing can reorder releases and certain older apps
    // are accidentally relying on the ordering.
    // rdar://problem/63886091
    if (!dyld_program_sdk_at_least(dyld_fall_2020_os_versions))
        DisableAutoreleaseCoalescingLRU = true;

    bool PrintHelp = false;
    bool PrintOptions = false;
    bool maybeMallocDebugging = false;

    // Scan environ[] directly instead of calling getenv() a lot.
    // This optimizes the case where none are set.
    for (char **p = *_NSGetEnviron(); *p != nil; p++) {
        if (0 == strncmp(*p, "Malloc", 6)  ||  0 == strncmp(*p, "DYLD", 4)  ||  
            0 == strncmp(*p, "NSZombiesEnabled", 16))
        {
            maybeMallocDebugging = true;
        }

        if (0 != strncmp(*p, "OBJC_", 5)) continue;
        
        if (0 == strncmp(*p, "OBJC_HELP=", 10)) {
            PrintHelp = true;
            continue;
        }
        if (0 == strncmp(*p, "OBJC_PRINT_OPTIONS=", 19)) {
            PrintOptions = true;
            continue;
        }
        
        if (0 == strncmp(*p, "OBJC_DEBUG_POOL_DEPTH=", 22)) {
            SetPageCountWarning(*p + 22);
            continue;
        }

        const char *value = strchr(*p, '=');
        if (!*value) continue;
        value++;
        
        for (size_t i = 0; i < sizeof(Settings)/sizeof(Settings[0]); i++) {
            const option_t *opt = &Settings[i];
            if ((size_t)(value - *p) == 1+opt->envlen  &&  
                0 == strncmp(*p, opt->env, opt->envlen))
            {
                *opt->var = (0 == strcmp(value, "YES"));
                break;
            }
        }
    }

    // Special case: enable some autorelease pool debugging
    // when some malloc debugging is enabled 
    // and OBJC_DEBUG_POOL_ALLOCATION is not set to something other than NO.
    if (maybeMallocDebugging) {
        const char *insert = getenv("DYLD_INSERT_LIBRARIES");
        const char *zombie = getenv("NSZombiesEnabled");
        const char *pooldebug = getenv("OBJC_DEBUG_POOL_ALLOCATION");
        if ((getenv("MallocStackLogging")
             || getenv("MallocStackLoggingNoCompact")
             || (zombie && (*zombie == 'Y' || *zombie == 'y'))
             || (insert && strstr(insert, "libgmalloc")))
            &&
            (!pooldebug || 0 == strcmp(pooldebug, "YES")))
        {
            DebugPoolAllocation = true;
        }
    }

    if (!os_feature_enabled_simple(objc4, preoptimizedCaches, true)) {
        DisablePreoptCaches = true;
    }

    // Print OBJC_HELP and OBJC_PRINT_OPTIONS output.
    if (PrintHelp  ||  PrintOptions) {
        if (PrintHelp) {
            _objc_inform("Objective-C runtime debugging. Set variable=YES to enable.");
            _objc_inform("OBJC_HELP: describe available environment variables");
            if (PrintOptions) {
                _objc_inform("OBJC_HELP is set");
            }
            _objc_inform("OBJC_PRINT_OPTIONS: list which options are set");
        }
        if (PrintOptions) {
            _objc_inform("OBJC_PRINT_OPTIONS is set");
        }

        for (size_t i = 0; i < sizeof(Settings)/sizeof(Settings[0]); i++) {
            const option_t *opt = &Settings[i];            
            if (PrintHelp) _objc_inform("%s: %s", opt->env, opt->help);
            if (PrintOptions && *opt->var) _objc_inform("%s is set", opt->env);
        }
    }
}
```



3.   `tls_init()`

`objc-runtime.mm` L.550

```objective-c
void tls_init(void)
{
#if SUPPORT_DIRECT_THREAD_KEYS
    pthread_key_init_np(TLS_DIRECT_KEY, &_objc_pthread_destroyspecific);
#else
    _objc_pthread_key = tls_create(&_objc_pthread_destroyspecific);
#endif
}
```



4.   `static_init()`



5.   `runtime_init()`

`objc-runtime-new.mm` L.8520

```objective-c
void runtime_init(void)
{
    objc::unattachedCategories.init(32);
    objc::allocatedClasses.init();
}
```



6.   `exception_init()`
7.   `cache_t::init()`
8.   ``





## 特殊的数据结构

1.   DisguisedPtr

     >   DisguisedPtr<T> acts like pointer type T*, except the stored value is disguised to hide it from tools like `leaks`.
     >
     >   nil is disguised as itself so zero-filled memory works as expected, which means 0x80..00 is also disguised as itself but we don't care.
     >
     >   Note that weak_entry_t knows about this encoding.

     ```c
     class DisguisedPtr {
         uintptr_t value;
         // ...
     }
     ```

     





## 特殊的二进制地址

>   The low two bits:

1.   `0b00`: pointer-aligned DisguisedPtr

     (disguised nil or 0x80..00)

2.   `0b11`: any other address

3.   `0b10`: mark the out-of-line state





## AutoRelease pool

### Definition

>   A thread’s autorelease pool is a stack of pointers.

一个线程的自动释放池是一个存放指针的栈。



>   Each pointer is either an object ot release, or POOL_BOUNDARY which is an autorelease pool boundary.

其中的每个指针要么是要释放的对象，要么是自动释放池的标记。



>   A pool token is a pointer to the POOL_BOUNDARY for that pool. When the pool is popped, every object hotter than the sentinel is released.

pool token是指向该自动释放池标记的指针。当该池弹出时，每个比标记更新( hotter )的对象都会被释放。



>   The stack is divided into a doubly-linkedlist of pages. Pages are added and deleted as necessary.

自动释放池的栈分成了使用双链表连接起来的数个页。这些页面的添加和删除是惰性的——需要的时候才会被添加/删除，而不是提前生成。



>   Thread-local storage points to the hot page, where newly autoreleased objects are stored.

线程本地（线程内部）存储指向了活跃的页面——新的自动释放的对象被存储的那一页。









## Weak

>   The weak table is a hash table governed by a single spin lock.
>
>   An allocated blob of memory, most often an object, but under GC any such allocation, may have its address stored in a __weak marked storage location through use of compiler generated write-barriers or hand coded uses of the register weak primitive. Associated with the registration can be a callback block for the case when one of the allocated chunks of memory is reclaimed. 
>
>   The table is hashed on the address of the allocated memory. When __weak marked memory changes its reference, we count on the fact that we can still see its previous reference.
>
>   So, in the hash table, indexed by the weakly referenced item, is a list of all locations where this address is currently being stored.
>
>   For ARC, we also keep track of whether an arbitrary object is being deallocated by briefly placing it in the table just prior to invoking dealloc, and removing it via objc_clear_deallocating just prior to memory reclamation.







## 方法调用



![image-20210909135253943](https://tva1.sinaimg.cn/large/008i3skNly1guabzh1pqqj60vd0u00v602.jpg)



1.   消息发送

     ![消息传递流程](https://tva1.sinaimg.cn/large/008i3skNly1gua7xi96jqj60zi0bywfh02.jpg)
     
     1.   快速查找
     
          ![img](https://tva1.sinaimg.cn/large/008i3skNly1gua81ao3tnj61ps0l0djo02.jpg)
     
     2.   慢速查找
     
          ![img](https://tva1.sinaimg.cn/large/008i3skNly1gua81t8ydmj61y40h6tcf02.jpg)

2.   消息转发

     ![消息转发流程](https://tva1.sinaimg.cn/large/008i3skNly1gua7wtw39lj60zk0hkjsj02.jpg)





## KVC

KVC在某种程度上提供了替代存取方法（访问器方法）的方案，不过存取方法终究是个好东西，以至于只要有可能，KVC也尽可能先尝试使用存取方法访问属性。当使用KVC访问属性时，它内部其实做了很多事：
1.首先查找有无<property>，set<property>，is<property>等property属性对应的存取方法，若有，则直接使用这些方法;
2.若无，则继续查找_<property>，_get<property>，*set<property>等方法，若有就使用；
3.若查询不到以上任何存取方法，则尝试直接访问实例变量<property>，*<property>；
4.若连该成员变量也访问不到，则会在下面方法中抛出异常。**之所以提供这两个方法，就是让你在因访问不到该属性而程序即将崩掉前，供你重写，在内做些处理，防止程序直接崩掉。**
`valueForUndefinedKey:`和`setValue:forUndefinedKey:`方法。

