; ModuleID = 'main-kernel.cu'
source_filename = "main-kernel.cu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.dim3 = type { i32, i32, i32 }

$_ZN4dim3C2Ejjj = comdat any

@__const.main.A = private unnamed_addr constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5], align 16
@__const.main.B = private unnamed_addr constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5], align 16
@.str = private unnamed_addr constant [5 x i8] c"%d, \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: mustprogress noinline norecurse optnone sspstrong uwtable
define dso_local void @_Z24__device_stub__vectorAddPiS_S_m(ptr noundef %0, ptr noundef %1, ptr noundef %2, i64 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i64, align 8
  %9 = alloca %struct.dim3, align 8
  %10 = alloca %struct.dim3, align 8
  %11 = alloca i64, align 8
  %12 = alloca ptr, align 8
  %13 = alloca { i64, i32 }, align 8
  %14 = alloca { i64, i32 }, align 8
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store ptr %2, ptr %7, align 8
  store i64 %3, ptr %8, align 8
  %15 = alloca ptr, i64 4, align 16
  %16 = getelementptr ptr, ptr %15, i32 0
  store ptr %5, ptr %16, align 8
  %17 = getelementptr ptr, ptr %15, i32 1
  store ptr %6, ptr %17, align 8
  %18 = getelementptr ptr, ptr %15, i32 2
  store ptr %7, ptr %18, align 8
  %19 = getelementptr ptr, ptr %15, i32 3
  store ptr %8, ptr %19, align 8
  %20 = call i32 @__cudaPopCallConfiguration(ptr %9, ptr %10, ptr %11, ptr %12)
  %21 = load i64, ptr %11, align 8
  %22 = load ptr, ptr %12, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %13, ptr align 8 %9, i64 12, i1 false)
  %23 = getelementptr inbounds nuw { i64, i32 }, ptr %13, i32 0, i32 0
  %24 = load i64, ptr %23, align 8
  %25 = getelementptr inbounds nuw { i64, i32 }, ptr %13, i32 0, i32 1
  %26 = load i32, ptr %25, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %14, ptr align 8 %10, i64 12, i1 false)
  %27 = getelementptr inbounds nuw { i64, i32 }, ptr %14, i32 0, i32 0
  %28 = load i64, ptr %27, align 8
  %29 = getelementptr inbounds nuw { i64, i32 }, ptr %14, i32 0, i32 1
  %30 = load i32, ptr %29, align 8
  %31 = call noundef i32 @cudaLaunchKernel(ptr noundef @_Z24__device_stub__vectorAddPiS_S_m, i64 %24, i32 %26, i64 %28, i32 %30, ptr noundef %15, i64 noundef %21, ptr noundef %22)
  br label %32

32:                                               ; preds = %4
  ret void
}

declare i32 @__cudaPopCallConfiguration(ptr, ptr, ptr, ptr)

declare i32 @cudaLaunchKernel(ptr, i64, i32, i64, i32, ptr, i64, ptr)

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1

; Function Attrs: mustprogress noinline norecurse optnone sspstrong uwtable
define dso_local noundef i32 @main() #2 {
  %1 = alloca i32, align 4
  %2 = alloca [5 x i32], align 16
  %3 = alloca [5 x i32], align 16
  %4 = alloca [5 x i32], align 16
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i64, align 8
  %9 = alloca %struct.dim3, align 4
  %10 = alloca %struct.dim3, align 4
  %11 = alloca { i64, i32 }, align 4
  %12 = alloca { i64, i32 }, align 4
  %13 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %2, ptr align 16 @__const.main.A, i64 20, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %3, ptr align 16 @__const.main.B, i64 20, i1 false)
  call void @llvm.memset.p0.i64(ptr align 16 %4, i8 0, i64 20, i1 false)
  store i64 20, ptr %8, align 8
  %14 = load i64, ptr %8, align 8
  %15 = call noundef i32 @_ZL10cudaMallocIiE9cudaErrorPPT_m(ptr noundef %5, i64 noundef %14)
  %16 = load i64, ptr %8, align 8
  %17 = call noundef i32 @_ZL10cudaMallocIiE9cudaErrorPPT_m(ptr noundef %6, i64 noundef %16)
  %18 = load i64, ptr %8, align 8
  %19 = call noundef i32 @_ZL10cudaMallocIiE9cudaErrorPPT_m(ptr noundef %7, i64 noundef %18)
  %20 = load ptr, ptr %5, align 8
  %21 = getelementptr inbounds [5 x i32], ptr %2, i64 0, i64 0
  %22 = load i64, ptr %8, align 8
  %23 = call i32 @cudaMemcpy(ptr noundef %20, ptr noundef %21, i64 noundef %22, i32 noundef 1)
  %24 = load ptr, ptr %6, align 8
  %25 = getelementptr inbounds [5 x i32], ptr %3, i64 0, i64 0
  %26 = load i64, ptr %8, align 8
  %27 = call i32 @cudaMemcpy(ptr noundef %24, ptr noundef %25, i64 noundef %26, i32 noundef 1)
  call void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %9, i32 noundef 1, i32 noundef 1, i32 noundef 1)
  call void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %10, i32 noundef 16, i32 noundef 1, i32 noundef 1)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %11, ptr align 4 %9, i64 12, i1 false)
  %28 = getelementptr inbounds nuw { i64, i32 }, ptr %11, i32 0, i32 0
  %29 = load i64, ptr %28, align 4
  %30 = getelementptr inbounds nuw { i64, i32 }, ptr %11, i32 0, i32 1
  %31 = load i32, ptr %30, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %12, ptr align 4 %10, i64 12, i1 false)
  %32 = getelementptr inbounds nuw { i64, i32 }, ptr %12, i32 0, i32 0
  %33 = load i64, ptr %32, align 4
  %34 = getelementptr inbounds nuw { i64, i32 }, ptr %12, i32 0, i32 1
  %35 = load i32, ptr %34, align 4
  %36 = call i32 @__cudaPushCallConfiguration(i64 %29, i32 %31, i64 %33, i32 %35, i64 noundef 0, ptr noundef null)
  %37 = icmp ne i32 %36, 0
  br i1 %37, label %42, label %38

38:                                               ; preds = %0
  %39 = load ptr, ptr %5, align 8
  %40 = load ptr, ptr %6, align 8
  %41 = load ptr, ptr %7, align 8
  call void @_Z24__device_stub__vectorAddPiS_S_m(ptr noundef %39, ptr noundef %40, ptr noundef %41, i64 noundef 5) #7
  br label %42

42:                                               ; preds = %38, %0
  %43 = getelementptr inbounds [5 x i32], ptr %4, i64 0, i64 0
  %44 = load ptr, ptr %7, align 8
  %45 = load i64, ptr %8, align 8
  %46 = call i32 @cudaMemcpy(ptr noundef %43, ptr noundef %44, i64 noundef %45, i32 noundef 2)
  store i32 0, ptr %13, align 4
  br label %47

47:                                               ; preds = %56, %42
  %48 = load i32, ptr %13, align 4
  %49 = icmp slt i32 %48, 5
  br i1 %49, label %50, label %59

50:                                               ; preds = %47
  %51 = load i32, ptr %13, align 4
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds [5 x i32], ptr %4, i64 0, i64 %52
  %54 = load i32, ptr %53, align 4
  %55 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %54)
  br label %56

56:                                               ; preds = %50
  %57 = load i32, ptr %13, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, ptr %13, align 4
  br label %47, !llvm.loop !7

59:                                               ; preds = %47
  %60 = call i32 (ptr, ...) @printf(ptr noundef @.str.1)
  ret i32 0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #3

; Function Attrs: mustprogress noinline optnone sspstrong uwtable
define internal noundef i32 @_ZL10cudaMallocIiE9cudaErrorPPT_m(ptr noundef %0, i64 noundef %1) #4 {
  %3 = alloca ptr, align 8
  %4 = alloca i64, align 8
  store ptr %0, ptr %3, align 8
  store i64 %1, ptr %4, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = load i64, ptr %4, align 8
  %7 = call i32 @cudaMalloc(ptr noundef %5, i64 noundef %6)
  ret i32 %7
}

declare i32 @cudaMemcpy(ptr noundef, ptr noundef, i64 noundef, i32 noundef) #5

declare i32 @__cudaPushCallConfiguration(i64, i32, i64, i32, i64 noundef, ptr noundef) #5

; Function Attrs: mustprogress noinline nounwind optnone sspstrong uwtable
define linkonce_odr dso_local void @_ZN4dim3C2Ejjj(ptr noundef nonnull align 4 dereferenceable(12) %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) unnamed_addr #6 comdat align 2 {
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  %9 = load ptr, ptr %5, align 8
  %10 = getelementptr inbounds nuw %struct.dim3, ptr %9, i32 0, i32 0
  %11 = load i32, ptr %6, align 4
  store i32 %11, ptr %10, align 4
  %12 = getelementptr inbounds nuw %struct.dim3, ptr %9, i32 0, i32 1
  %13 = load i32, ptr %7, align 4
  store i32 %13, ptr %12, align 4
  %14 = getelementptr inbounds nuw %struct.dim3, ptr %9, i32 0, i32 2
  %15 = load i32, ptr %8, align 4
  store i32 %15, ptr %14, align 4
  ret void
}

declare i32 @printf(ptr noundef, ...) #5

declare i32 @cudaMalloc(ptr noundef, i64 noundef) #5

attributes #0 = { mustprogress noinline norecurse optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "uniform-work-group-size"="true" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress noinline norecurse optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { mustprogress noinline optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { mustprogress noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { "uniform-work-group-size"="true" }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 12, i32 9]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{!"clang version 22.1.8"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
