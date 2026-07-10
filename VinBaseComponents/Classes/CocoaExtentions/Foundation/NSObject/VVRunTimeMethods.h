//
//  VVRunTimeMethods.h
//  VinBaseComponents
//
//  Created by vin on 2021/5/25.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define vv_ImpFuctoin(_imp, ...) \
do { \
    IMP __vv_imp = (_imp); \
    if (__vv_imp) { \
        ((void (*)(id, SEL, ...))__vv_imp)(__VA_ARGS__); \
    } \
} while (0)

#define vv_ValueImpFuctoin(_imp, _type,...) \
({ \
    _type __vv_value = {0}; \
    IMP __vv_imp = (_imp); \
    if (__vv_imp) { \
        __vv_value = ((_type (*)(id, SEL, ...))__vv_imp)(__VA_ARGS__); \
    } \
    __vv_value; \
})

#define vv_ProtocolAndSelector(_object, _Protocol, _Selector) \
({ \
    id __vv_object = (_object); \
    [__vv_object conformsToProtocol:(_Protocol)] && \
    [__vv_object respondsToSelector:(_Selector)]; \
})

#pragma mark - Method（以下实现来自QMUI, Thanks to QMUI team）

CG_INLINE BOOL
vv_HasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    if (!targetClass || !targetSelector) return NO;

    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;

    Class superclass = class_getSuperclass(targetClass);
    Method methodOfSuperclass = superclass ? class_getInstanceMethod(superclass, targetSelector) : NULL;
    if (!methodOfSuperclass) return YES;

    return method != methodOfSuperclass;
}

CG_INLINE IMP
vv_OriginalImplementation(BOOL resolvesDynamically,
                          IMP cachedImplementation,
                          IMP (^originalIMPProvider)(void)) {
    return resolvesDynamically ? originalIMPProvider() : cachedImplementation;
}

CG_INLINE void
vv_EmptyMethodImplementation(__unused id selfObject, __unused SEL selector) {}

/**
 *  如果 fromClass 里存在 originSelector，则这个函数会将 fromClass 里的 originSelector 与 toClass 里的 newSelector 交换实现。
 *  如果 fromClass 里不存在 originSelecotr，则这个函数会为 fromClass 增加方法 originSelector，并且该方法会使用 toClass 的 newSelector 方法的实现，而 toClass 的 newSelector 方法的实现则会被替换为空内容
 *  @warning 注意如果 fromClass 里的 originSelector 是继承自父类并且 fromClass 也没有重写这个方法，这会导致实际上被替换的是父类，然后父类及父类的所有子类（也即 fromClass 的兄弟类）也受影响，因此使用时请谨记这一点。因此建议使用 OverrideImplementation 系列的方法去替换，尽量避免使用 ExchangeImplementations。
 *  @param _fromClass 要被替换的 class，不能为空
 *  @param _originSelector 要被替换的 class 的 selector，不能为空；方法不存在时相当于为 fromClass 新增该方法
 *  @param _toClass 要拿这个 class 的方法来替换
 *  @param _newSelector 要拿 toClass 里的这个方法来替换 originSelector
 *  @return 是否成功替换（或增加）
 */
CG_INLINE BOOL
vv_ExchangeImplementationsInTwoClasses(Class _fromClass, SEL _originSelector, Class _toClass, SEL _newSelector) {
    if (!_fromClass || !_originSelector || !_toClass || !_newSelector) {
        return NO;
    }

    Method oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
    Method newMethod = class_getInstanceMethod(_toClass, _newSelector);
    if (!newMethod) {
        return NO;
    }

    IMP newImplementation = method_getImplementation(newMethod);
    const char *newTypeEncoding = method_getTypeEncoding(newMethod);
    BOOL isAddedMethod = class_addMethod(_fromClass, _originSelector, newImplementation, newTypeEncoding);
    if (isAddedMethod) {
        // 如果 class_addMethod 成功了，说明之前 fromClass 里并不存在 originSelector，所以要用一个空的方法代替它，以避免 class_replaceMethod 后，后续 toClass 的这个方法被调用时可能会 crash
        IMP oriMethodIMP = oriMethod ? method_getImplementation(oriMethod) : (IMP)vv_EmptyMethodImplementation;
        const char *oriMethodTypeEncoding = oriMethod ? method_getTypeEncoding(oriMethod) : newTypeEncoding;
        class_replaceMethod(_toClass, _newSelector, oriMethodIMP, oriMethodTypeEncoding);
    } else {
        oriMethod = class_getInstanceMethod(_fromClass, _originSelector);
        if (!oriMethod) return NO;
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}

/// 交换同一个 class 里的 originSelector 和 newSelector 的实现，如果原本不存在 originSelector，则相当于给 class 新增一个叫做 originSelector 的方法
CG_INLINE BOOL
vv_ExchangeImplementations(Class _class, SEL _originSelector, SEL _newSelector) {
    return vv_ExchangeImplementationsInTwoClasses(_class, _originSelector, _class, _newSelector);
}

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是一个 block，用于获取 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
vv_OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    if (!targetClass || !targetSelector || !implementationBlock) return NO;

    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) return NO;

    IMP originalImplementation = method_getImplementation(originMethod);
    if (!originalImplementation) return NO;

    BOOL hasOverride = vv_HasOverrideSuperclassMethod(targetClass, targetSelector);

    // 以 block 的方式达到实时获取初始方法的 IMP 的目的，从而避免先 swizzle 了 subclass 的方法，再 swizzle superclass 的方法，会发现前者调用时不会触发后者 swizzle 后的版本的 bug。
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        if (hasOverride) {
            return originalImplementation;
        }

        Class superclass = class_getSuperclass(targetClass);
        IMP currentImplementation = superclass ? class_getMethodImplementation(superclass, targetSelector) : NULL;
        return currentImplementation ?: originalImplementation;
    };

    id newImplementationBlock = implementationBlock(targetClass, targetSelector, originalIMPProvider);
    if (!newImplementationBlock) return NO;

    IMP newImplementation = imp_implementationWithBlock(newImplementationBlock);
    if (!newImplementation) return NO;

    if (hasOverride) {
        method_setImplementation(originMethod, newImplementation);
        return YES;
    }

    BOOL added = class_addMethod(targetClass,
                                 targetSelector,
                                 newImplementation,
                                 method_getTypeEncoding(originMethod));
    if (!added) {
        imp_removeBlock(newImplementation);
    }
    return added;
}

/**
 *  用 block 重写某个 class 的某个无参数且返回值为 void 的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须无参数，返回值为 void
 *  @param implementationBlock targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针。
 */
CG_INLINE BOOL
vv_ExtendImplementationOfVoidMethodWithoutArguments(Class targetClass, SEL targetSelector, void (^implementationBlock)(__kindof NSObject *selfObject)) {
    if (!implementationBlock) return NO;

    return vv_OverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        BOOL resolvesOriginalDynamically = !vv_HasOverrideSuperclassMethod(originClass, originCMD);
        IMP cachedOriginalImplementation = resolvesOriginalDynamically ? NULL : originalIMPProvider();
        void (^block)(__unsafe_unretained __kindof NSObject *selfObject) = ^(__unsafe_unretained __kindof NSObject *selfObject) {
            IMP originalImplementation = vv_OriginalImplementation(resolvesOriginalDynamically,
                                                                    cachedOriginalImplementation,
                                                                    originalIMPProvider);
            void (*originSelectorIMP)(id, SEL) = (void (*)(id, SEL))originalImplementation;
            originSelectorIMP(selfObject, originCMD);

            implementationBlock(selfObject);
        };
        #if __has_feature(objc_arc)
        return block;
        #else
        return [block copy];
        #endif
    });
}

/**
 *  用 block 重写某个 class 的某个无参数且带返回值的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param _targetClass 要重写的 class
 *  @param _targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须带一个参数，返回值不为空
 *  @param _returnType 返回值的数据类型
 *  @param _implementationBlock 格式为 ^_returnType(NSObject *selfObject, _returnType originReturnValue) {}，内容即为 targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。第一个参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针；第二个参数 originReturnValue 代表 super 的返回值，具体类型请自行填写
 */
#define vv_ExtendImplementationOfNonVoidMethodWithoutArguments(_targetClass, _targetSelector, _returnType, _implementationBlock) vv_OverrideImplementation((_targetClass), (_targetSelector), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
            __typeof__(_implementationBlock) extensionBlock = [_implementationBlock copy];\
            if (!extensionBlock) return nil;\
            BOOL resolvesOriginalDynamically = !vv_HasOverrideSuperclassMethod(originClass, originCMD);\
            IMP cachedOriginalImplementation = resolvesOriginalDynamically ? NULL : originalIMPProvider();\
            return ^_returnType (__unsafe_unretained __kindof NSObject *selfObject) {\
                IMP originalImplementation = vv_OriginalImplementation(resolvesOriginalDynamically, cachedOriginalImplementation, originalIMPProvider);\
                _returnType (*originSelectorIMP)(id, SEL) = (_returnType (*)(id, SEL))originalImplementation;\
                _returnType result = originSelectorIMP(selfObject, originCMD);\
                return extensionBlock(selfObject, result);\
            };\
        })

/**
 *  用 block 重写某个 class 的带一个参数且返回值为 void 的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param _targetClass 要重写的 class
 *  @param _targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须带一个参数，返回值为 void
 *  @param _argumentType targetSelector 的参数类型
 *  @param _implementationBlock 格式为 ^(NSObject *selfObject, _argumentType firstArgv) {}，内容即为 targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。第一个参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针；第二个参数 firstArgv 代表 targetSelector 被调用时传进来的第一个参数，具体的类型请自行填写
 */
#define vv_ExtendImplementationOfVoidMethodWithSingleArgument(_targetClass, _targetSelector, _argumentType, _implementationBlock) vv_OverrideImplementation((_targetClass), (_targetSelector), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
        __typeof__(_implementationBlock) extensionBlock = [_implementationBlock copy];\
        if (!extensionBlock) return nil;\
        BOOL resolvesOriginalDynamically = !vv_HasOverrideSuperclassMethod(originClass, originCMD);\
        IMP cachedOriginalImplementation = resolvesOriginalDynamically ? NULL : originalIMPProvider();\
        return ^(__unsafe_unretained __kindof NSObject *selfObject, _argumentType firstArgv) {\
            IMP originalImplementation = vv_OriginalImplementation(resolvesOriginalDynamically, cachedOriginalImplementation, originalIMPProvider);\
            void (*originSelectorIMP)(id, SEL, _argumentType) = (void (*)(id, SEL, _argumentType))originalImplementation;\
            originSelectorIMP(selfObject, originCMD, firstArgv);\
            extensionBlock(selfObject, firstArgv);\
        };\
    })

#define ExtendImplementationOfVoidMethodWithTwoArguments(_targetClass, _targetSelector, _argumentType1, _argumentType2, _implementationBlock) vv_OverrideImplementation((_targetClass), (_targetSelector), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
        __typeof__(_implementationBlock) extensionBlock = [_implementationBlock copy];\
        if (!extensionBlock) return nil;\
        BOOL resolvesOriginalDynamically = !vv_HasOverrideSuperclassMethod(originClass, originCMD);\
        IMP cachedOriginalImplementation = resolvesOriginalDynamically ? NULL : originalIMPProvider();\
        return ^(__unsafe_unretained __kindof NSObject *selfObject, _argumentType1 firstArgv, _argumentType2 secondArgv) {\
            IMP originalImplementation = vv_OriginalImplementation(resolvesOriginalDynamically, cachedOriginalImplementation, originalIMPProvider);\
            void (*originSelectorIMP)(id, SEL, _argumentType1, _argumentType2) = (void (*)(id, SEL, _argumentType1, _argumentType2))originalImplementation;\
            originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);\
            extensionBlock(selfObject, firstArgv, secondArgv);\
        };\
    })

/**
 *  用 block 重写某个 class 的带一个参数且带返回值的方法，会自动在调用 block 之前先调用该方法原本的实现。
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做，注意该方法必须带一个参数，返回值不为空
 *  @param implementationBlock，格式为 ^_returnType (NSObject *selfObject, _argumentType firstArgv, _returnType originReturnValue){}，内容也即 targetSelector 的自定义实现，直接将你的实现写进去即可，不需要管 super 的调用。第一个参数 selfObject 代表当前正在调用这个方法的对象，也即 self 指针；第二个参数 firstArgv 代表 targetSelector 被调用时传进来的第一个参数，具体的类型请自行填写；第三个参数 originReturnValue 代表 super 的返回值，具体类型请自行填写
 */
#define vv_ExtendImplementationOfNonVoidMethodWithSingleArgument(_targetClass, _targetSelector, _argumentType, _returnType, _implementationBlock) vv_OverrideImplementation((_targetClass), (_targetSelector), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
        __typeof__(_implementationBlock) extensionBlock = [_implementationBlock copy];\
        if (!extensionBlock) return nil;\
        BOOL resolvesOriginalDynamically = !vv_HasOverrideSuperclassMethod(originClass, originCMD);\
        IMP cachedOriginalImplementation = resolvesOriginalDynamically ? NULL : originalIMPProvider();\
        return ^_returnType (__unsafe_unretained __kindof NSObject *selfObject, _argumentType firstArgv) {\
            IMP originalImplementation = vv_OriginalImplementation(resolvesOriginalDynamically, cachedOriginalImplementation, originalIMPProvider);\
            _returnType (*originSelectorIMP)(id, SEL, _argumentType) = (_returnType (*)(id, SEL, _argumentType))originalImplementation;\
            _returnType result = originSelectorIMP(selfObject, originCMD, firstArgv);\
            return extensionBlock(selfObject, firstArgv, result);\
        };\
    })

#define vv_ExtendImplementationOfNonVoidMethodWithTwoArguments(_targetClass, _targetSelector, _argumentType1, _argumentType2, _returnType, _implementationBlock) vv_OverrideImplementation((_targetClass), (_targetSelector), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
        __typeof__(_implementationBlock) extensionBlock = [_implementationBlock copy];\
        if (!extensionBlock) return nil;\
        BOOL resolvesOriginalDynamically = !vv_HasOverrideSuperclassMethod(originClass, originCMD);\
        IMP cachedOriginalImplementation = resolvesOriginalDynamically ? NULL : originalIMPProvider();\
        return ^_returnType (__unsafe_unretained __kindof NSObject *selfObject, _argumentType1 firstArgv, _argumentType2 secondArgv) {\
            IMP originalImplementation = vv_OriginalImplementation(resolvesOriginalDynamically, cachedOriginalImplementation, originalIMPProvider);\
            _returnType (*originSelectorIMP)(id, SEL, _argumentType1, _argumentType2) = (_returnType (*)(id, SEL, _argumentType1, _argumentType2))originalImplementation;\
            _returnType result = originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);\
            return extensionBlock(selfObject, firstArgv, secondArgv, result);\
        };\
    })
