; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

@nl = internal constant [2 x i8] c"\0A\00"
@frmt_spec = internal constant [4 x i8] c"%f \00"

declare void @free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @malloc(i64)

define void @main() {
  %1 = call ptr @malloc(i64 4)
  %2 = insertvalue { ptr, ptr, i64 } poison, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64 } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64 } %3, i64 0, 2
  %5 = call ptr @malloc(i64 4)
  %6 = insertvalue { ptr, ptr, i64 } poison, ptr %5, 0
  %7 = insertvalue { ptr, ptr, i64 } %6, ptr %5, 1
  %8 = insertvalue { ptr, ptr, i64 } %7, i64 0, 2
  %9 = call ptr @malloc(i64 64)
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %9, 0
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, ptr %9, 1
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 0, 2
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 4, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 4, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 4, 4, 0
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, i64 1, 4, 1
  %17 = call ptr @malloc(i64 64)
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %17, 0
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, ptr %17, 1
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 0, 2
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 4, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 4, 3, 1
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, i64 4, 4, 0
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 1, 4, 1
  %25 = call ptr @malloc(i64 64)
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } poison, ptr %25, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, ptr %25, 1
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 0, 2
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, i64 4, 3, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, i64 4, 3, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 4, 4, 0
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 1, 4, 1
  %33 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %34 = getelementptr inbounds nuw float, ptr %33, i64 0
  store float 1.000000e+00, ptr %34, align 4
  %35 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %36 = getelementptr inbounds nuw float, ptr %35, i64 1
  store float 2.000000e+00, ptr %36, align 4
  %37 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %38 = getelementptr inbounds nuw float, ptr %37, i64 2
  store float 3.000000e+00, ptr %38, align 4
  %39 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %40 = getelementptr inbounds nuw float, ptr %39, i64 3
  store float 4.000000e+00, ptr %40, align 4
  %41 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %42 = getelementptr inbounds nuw float, ptr %41, i64 4
  store float 2.000000e+00, ptr %42, align 4
  %43 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %44 = getelementptr inbounds nuw float, ptr %43, i64 5
  store float 0.000000e+00, ptr %44, align 4
  %45 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %46 = getelementptr inbounds nuw float, ptr %45, i64 6
  store float 1.000000e+00, ptr %46, align 4
  %47 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %48 = getelementptr inbounds nuw float, ptr %47, i64 7
  store float 3.000000e+00, ptr %48, align 4
  %49 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %50 = getelementptr inbounds nuw float, ptr %49, i64 8
  store float 1.000000e+00, ptr %50, align 4
  %51 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %52 = getelementptr inbounds nuw float, ptr %51, i64 9
  store float 1.000000e+00, ptr %52, align 4
  %53 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %54 = getelementptr inbounds nuw float, ptr %53, i64 10
  store float 0.000000e+00, ptr %54, align 4
  %55 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %56 = getelementptr inbounds nuw float, ptr %55, i64 11
  store float 2.000000e+00, ptr %56, align 4
  %57 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %58 = getelementptr inbounds nuw float, ptr %57, i64 12
  store float 3.000000e+00, ptr %58, align 4
  %59 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %60 = getelementptr inbounds nuw float, ptr %59, i64 13
  store float 2.000000e+00, ptr %60, align 4
  %61 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %62 = getelementptr inbounds nuw float, ptr %61, i64 14
  store float 1.000000e+00, ptr %62, align 4
  %63 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %64 = getelementptr inbounds nuw float, ptr %63, i64 15
  store float 0.000000e+00, ptr %64, align 4
  %65 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %66 = getelementptr inbounds nuw float, ptr %65, i64 0
  store float 1.000000e+00, ptr %66, align 4
  %67 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %68 = getelementptr inbounds nuw float, ptr %67, i64 1
  store float 0.000000e+00, ptr %68, align 4
  %69 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %70 = getelementptr inbounds nuw float, ptr %69, i64 2
  store float 2.000000e+00, ptr %70, align 4
  %71 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %72 = getelementptr inbounds nuw float, ptr %71, i64 3
  store float 1.000000e+00, ptr %72, align 4
  %73 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %74 = getelementptr inbounds nuw float, ptr %73, i64 4
  store float 0.000000e+00, ptr %74, align 4
  %75 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %76 = getelementptr inbounds nuw float, ptr %75, i64 5
  store float 1.000000e+00, ptr %76, align 4
  %77 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %78 = getelementptr inbounds nuw float, ptr %77, i64 6
  store float 1.000000e+00, ptr %78, align 4
  %79 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %80 = getelementptr inbounds nuw float, ptr %79, i64 7
  store float 2.000000e+00, ptr %80, align 4
  %81 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %82 = getelementptr inbounds nuw float, ptr %81, i64 8
  store float 1.000000e+00, ptr %82, align 4
  %83 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %84 = getelementptr inbounds nuw float, ptr %83, i64 9
  store float 1.000000e+00, ptr %84, align 4
  %85 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %86 = getelementptr inbounds nuw float, ptr %85, i64 10
  store float 0.000000e+00, ptr %86, align 4
  %87 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %88 = getelementptr inbounds nuw float, ptr %87, i64 11
  store float 1.000000e+00, ptr %88, align 4
  %89 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %90 = getelementptr inbounds nuw float, ptr %89, i64 12
  store float 2.000000e+00, ptr %90, align 4
  %91 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %92 = getelementptr inbounds nuw float, ptr %91, i64 13
  store float 1.000000e+00, ptr %92, align 4
  %93 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %94 = getelementptr inbounds nuw float, ptr %93, i64 14
  store float 1.000000e+00, ptr %94, align 4
  %95 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %96 = getelementptr inbounds nuw float, ptr %95, i64 15
  store float 0.000000e+00, ptr %96, align 4
  %97 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %98 = getelementptr inbounds nuw float, ptr %97, i64 0
  store float 0.000000e+00, ptr %98, align 4
  %99 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %100 = getelementptr inbounds nuw float, ptr %99, i64 1
  store float 0.000000e+00, ptr %100, align 4
  %101 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %102 = getelementptr inbounds nuw float, ptr %101, i64 2
  store float 0.000000e+00, ptr %102, align 4
  %103 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %104 = getelementptr inbounds nuw float, ptr %103, i64 3
  store float 0.000000e+00, ptr %104, align 4
  %105 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %106 = getelementptr inbounds nuw float, ptr %105, i64 4
  store float 0.000000e+00, ptr %106, align 4
  %107 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %108 = getelementptr inbounds nuw float, ptr %107, i64 5
  store float 0.000000e+00, ptr %108, align 4
  %109 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %110 = getelementptr inbounds nuw float, ptr %109, i64 6
  store float 0.000000e+00, ptr %110, align 4
  %111 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %112 = getelementptr inbounds nuw float, ptr %111, i64 7
  store float 0.000000e+00, ptr %112, align 4
  %113 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %114 = getelementptr inbounds nuw float, ptr %113, i64 8
  store float 0.000000e+00, ptr %114, align 4
  %115 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %116 = getelementptr inbounds nuw float, ptr %115, i64 9
  store float 0.000000e+00, ptr %116, align 4
  %117 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %118 = getelementptr inbounds nuw float, ptr %117, i64 10
  store float 0.000000e+00, ptr %118, align 4
  %119 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %120 = getelementptr inbounds nuw float, ptr %119, i64 11
  store float 0.000000e+00, ptr %120, align 4
  %121 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %122 = getelementptr inbounds nuw float, ptr %121, i64 12
  store float 0.000000e+00, ptr %122, align 4
  %123 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %124 = getelementptr inbounds nuw float, ptr %123, i64 13
  store float 0.000000e+00, ptr %124, align 4
  %125 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %126 = getelementptr inbounds nuw float, ptr %125, i64 14
  store float 0.000000e+00, ptr %126, align 4
  %127 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %128 = getelementptr inbounds nuw float, ptr %127, i64 15
  store float 0.000000e+00, ptr %128, align 4
  %129 = extractvalue { ptr, ptr, i64 } %8, 1
  store i32 0, ptr %129, align 4
  %130 = extractvalue { ptr, ptr, i64 } %4, 1
  store i32 1, ptr %130, align 4
  %131 = extractvalue { ptr, ptr, i64 } %8, 1
  %132 = load i32, ptr %131, align 4
  %133 = extractvalue { ptr, ptr, i64 } %4, 1
  %134 = load i32, ptr %133, align 4
  %135 = sext i32 %132 to i64
  %136 = sext i32 %134 to i64
  br label %137

137:                                              ; preds = %192, %0
  %138 = phi i64 [ %135, %0 ], [ %193, %192 ]
  %139 = icmp slt i64 %138, 4
  br i1 %139, label %140, label %194

140:                                              ; preds = %137
  %141 = trunc i64 %138 to i32
  %142 = extractvalue { ptr, ptr, i64 } %8, 1
  %143 = load i32, ptr %142, align 4
  %144 = extractvalue { ptr, ptr, i64 } %4, 1
  %145 = load i32, ptr %144, align 4
  %146 = sext i32 %143 to i64
  %147 = sext i32 %145 to i64
  br label %148

148:                                              ; preds = %190, %140
  %149 = phi i64 [ %146, %140 ], [ %191, %190 ]
  %150 = icmp slt i64 %149, 4
  br i1 %150, label %151, label %192

151:                                              ; preds = %148
  %152 = trunc i64 %149 to i32
  %153 = extractvalue { ptr, ptr, i64 } %8, 1
  %154 = load i32, ptr %153, align 4
  %155 = extractvalue { ptr, ptr, i64 } %4, 1
  %156 = load i32, ptr %155, align 4
  %157 = sext i32 %154 to i64
  %158 = sext i32 %156 to i64
  br label %159

159:                                              ; preds = %188, %151
  %160 = phi i64 [ %157, %151 ], [ %189, %188 ]
  %161 = icmp slt i64 %160, 4
  br i1 %161, label %162, label %190

162:                                              ; preds = %159
  %163 = icmp slt i32 %141, 4
  %164 = icmp slt i32 %152, 4
  %165 = and i1 %163, %164
  %166 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 1
  %167 = mul nuw nsw i64 %138, 4
  %168 = add nuw nsw i64 %167, %160
  %169 = getelementptr inbounds nuw float, ptr %166, i64 %168
  %170 = load float, ptr %169, align 4
  %171 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 1
  %172 = mul nuw nsw i64 %160, 4
  %173 = add nuw nsw i64 %172, %149
  %174 = getelementptr inbounds nuw float, ptr %171, i64 %173
  %175 = load float, ptr %174, align 4
  %176 = fmul float %170, %175
  %177 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %178 = mul nuw nsw i64 %138, 4
  %179 = add nuw nsw i64 %178, %149
  %180 = getelementptr inbounds nuw float, ptr %177, i64 %179
  %181 = load float, ptr %180, align 4
  %182 = fadd float %181, %176
  br i1 %165, label %183, label %188

183:                                              ; preds = %162
  %184 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %185 = mul nuw nsw i64 %138, 4
  %186 = add nuw nsw i64 %185, %149
  %187 = getelementptr inbounds nuw float, ptr %184, i64 %186
  store float %182, ptr %187, align 4
  br label %188

188:                                              ; preds = %183, %162
  %189 = add i64 %160, %158
  br label %159

190:                                              ; preds = %159
  %191 = add i64 %149, %147
  br label %148

192:                                              ; preds = %148
  %193 = add i64 %138, %136
  br label %137

194:                                              ; preds = %137
  br label %195

195:                                              ; preds = %211, %194
  %196 = phi i64 [ 0, %194 ], [ %213, %211 ]
  %197 = icmp slt i64 %196, 4
  br i1 %197, label %198, label %214

198:                                              ; preds = %195
  br label %199

199:                                              ; preds = %202, %198
  %200 = phi i64 [ 0, %198 ], [ %210, %202 ]
  %201 = icmp slt i64 %200, 4
  br i1 %201, label %202, label %211

202:                                              ; preds = %199
  %203 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %204 = mul nuw nsw i64 %196, 4
  %205 = add nuw nsw i64 %204, %200
  %206 = getelementptr inbounds nuw float, ptr %203, i64 %205
  %207 = load float, ptr %206, align 4
  %208 = fpext float %207 to double
  %209 = call i32 (ptr, ...) @printf(ptr @frmt_spec, double %208)
  %210 = add i64 %200, 1
  br label %199

211:                                              ; preds = %199
  %212 = call i32 (ptr, ...) @printf(ptr @nl)
  %213 = add i64 %196, 1
  br label %195

214:                                              ; preds = %195
  %215 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 0
  %216 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %217 = insertvalue { ptr, ptr, i64 } poison, ptr %215, 0
  %218 = insertvalue { ptr, ptr, i64 } %217, ptr %216, 1
  %219 = insertvalue { ptr, ptr, i64 } %218, i64 0, 2
  %220 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 2
  %221 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 0
  %222 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 3, 1
  %223 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 0
  %224 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 4, 1
  %225 = extractvalue { ptr, ptr, i64 } %4, 0
  call void @free(ptr %225)
  %226 = extractvalue { ptr, ptr, i64 } %8, 0
  call void @free(ptr %226)
  %227 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, 0
  call void @free(ptr %227)
  %228 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, 0
  call void @free(ptr %228)
  %229 = call ptr @malloc(i64 16)
  %230 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %229, 0
  %231 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %230, ptr %229, 1
  %232 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %231, i64 0, 2
  %233 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %232, i64 2, 3, 0
  %234 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %233, i64 1, 4, 0
  %235 = call ptr @malloc(i64 2)
  %236 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %235, 0
  %237 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %236, ptr %235, 1
  %238 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %237, i64 0, 2
  %239 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %238, i64 2, 3, 0
  %240 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %239, i64 1, 4, 0
  %241 = call ptr @malloc(i64 0)
  %242 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %241, 0
  %243 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %242, ptr %241, 1
  %244 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %243, i64 0, 2
  %245 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %244, i64 0, 3, 0
  %246 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %245, i64 1, 4, 0
  %247 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 1
  %248 = ptrtoint ptr %247 to i64
  %249 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %250 = getelementptr inbounds nuw i64, ptr %249, i64 0
  store i64 %248, ptr %250, align 4
  %251 = extractvalue { ptr, ptr, i64 } %219, 1
  %252 = ptrtoint ptr %251 to i64
  %253 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %254 = getelementptr inbounds nuw i64, ptr %253, i64 1
  store i64 %252, ptr %254, align 4
  %255 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 1
  %256 = getelementptr inbounds nuw i1, ptr %255, i64 0
  store i1 true, ptr %256, align 1
  %257 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 1
  %258 = getelementptr inbounds nuw i1, ptr %257, i64 1
  store i1 false, ptr %258, align 1
  %259 = call ptr @malloc(i64 2)
  %260 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %259, 0
  %261 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %260, ptr %259, 1
  %262 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %261, i64 0, 2
  %263 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %262, i64 2, 3, 0
  %264 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %263, i64 1, 4, 0
  %265 = call ptr @malloc(i64 0)
  %266 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %265, 0
  %267 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %266, ptr %265, 1
  %268 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %267, i64 0, 2
  %269 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %268, i64 0, 3, 0
  %270 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %269, i64 1, 4, 0
  %271 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 0
  %272 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 1
  %273 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 2
  %274 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 3, 0
  %275 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 4, 0
  %276 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %246, 0
  %277 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %246, 1
  %278 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %246, 2
  %279 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %246, 3, 0
  %280 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %246, 4, 0
  %281 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 0
  %282 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 1
  %283 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 2
  %284 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 3, 0
  %285 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 4, 0
  %286 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 0
  %287 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 1
  %288 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 2
  %289 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 3, 0
  %290 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 4, 0
  %291 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %270, 0
  %292 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %270, 1
  %293 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %270, 2
  %294 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %270, 3, 0
  %295 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %270, 4, 0
  call void @dealloc_helper(ptr %271, ptr %272, i64 %273, i64 %274, i64 %275, ptr %276, ptr %277, i64 %278, i64 %279, i64 %280, ptr %281, ptr %282, i64 %283, i64 %284, i64 %285, ptr %286, ptr %287, i64 %288, i64 %289, i64 %290, ptr %291, ptr %292, i64 %293, i64 %294, i64 %295)
  %296 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 1
  %297 = getelementptr inbounds nuw i1, ptr %296, i64 0
  %298 = load i1, ptr %297, align 1
  br i1 %298, label %299, label %301

299:                                              ; preds = %214
  %300 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %16, 0
  call void @free(ptr %300)
  br label %301

301:                                              ; preds = %299, %214
  %302 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 1
  %303 = getelementptr inbounds nuw i1, ptr %302, i64 1
  %304 = load i1, ptr %303, align 1
  br i1 %304, label %305, label %307

305:                                              ; preds = %301
  %306 = extractvalue { ptr, ptr, i64 } %219, 0
  call void @free(ptr %306)
  br label %307

307:                                              ; preds = %305, %301
  %308 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %234, 0
  call void @free(ptr %308)
  %309 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %246, 0
  call void @free(ptr %309)
  %310 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %240, 0
  call void @free(ptr %310)
  %311 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %264, 0
  call void @free(ptr %311)
  %312 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %270, 0
  call void @free(ptr %312)
  ret void
}

define void @dealloc_helper(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, ptr %15, ptr %16, i64 %17, i64 %18, i64 %19, ptr %20, ptr %21, i64 %22, i64 %23, i64 %24) {
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %15, 0
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, ptr %16, 1
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, i64 %17, 2
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, i64 %18, 3, 0
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, i64 %19, 4, 0
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %10, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, ptr %11, 1
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, i64 %12, 2
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, i64 %13, 3, 0
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %14, 4, 0
  %36 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %20, 0
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %36, ptr %21, 1
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, i64 %22, 2
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, i64 %23, 3, 0
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %24, 4, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %5, 0
  %42 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, ptr %6, 1
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %42, i64 %7, 2
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, i64 %8, 3, 0
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, i64 %9, 4, 0
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } poison, ptr %0, 0
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, ptr %1, 1
  %48 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, i64 %2, 2
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %48, i64 %3, 3, 0
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, i64 %4, 4, 0
  %51 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, 3, 0
  %52 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, 3, 0
  br label %53

53:                                               ; preds = %56, %25
  %54 = phi i64 [ 0, %25 ], [ %59, %56 ]
  %55 = icmp slt i64 %54, %52
  br i1 %55, label %56, label %60

56:                                               ; preds = %53
  %57 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, 1
  %58 = getelementptr inbounds nuw i1, ptr %57, i64 %54
  store i1 false, ptr %58, align 1
  %59 = add i64 %54, 1
  br label %53

60:                                               ; preds = %53
  br label %61

61:                                               ; preds = %103, %60
  %62 = phi i64 [ 0, %60 ], [ %107, %103 ]
  %63 = icmp slt i64 %62, %51
  br i1 %63, label %64, label %108

64:                                               ; preds = %61
  %65 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, 1
  %66 = getelementptr inbounds nuw i64, ptr %65, i64 %62
  %67 = load i64, ptr %66, align 4
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, 1
  %69 = getelementptr inbounds nuw i1, ptr %68, i64 %62
  %70 = load i1, ptr %69, align 1
  br label %71

71:                                               ; preds = %87, %64
  %72 = phi i64 [ 0, %64 ], [ %90, %87 ]
  %73 = phi i1 [ true, %64 ], [ %89, %87 ]
  %74 = icmp slt i64 %72, %52
  br i1 %74, label %75, label %91

75:                                               ; preds = %71
  %76 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, 1
  %77 = getelementptr inbounds nuw i64, ptr %76, i64 %72
  %78 = load i64, ptr %77, align 4
  %79 = icmp eq i64 %78, %67
  br i1 %79, label %80, label %87

80:                                               ; preds = %75
  %81 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, 1
  %82 = getelementptr inbounds nuw i1, ptr %81, i64 %72
  %83 = load i1, ptr %82, align 1
  %84 = or i1 %83, %70
  %85 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, 1
  %86 = getelementptr inbounds nuw i1, ptr %85, i64 %72
  store i1 %84, ptr %86, align 1
  br label %87

87:                                               ; preds = %80, %75
  %88 = icmp ne i64 %78, %67
  %89 = and i1 %73, %88
  %90 = add i64 %72, 1
  br label %71

91:                                               ; preds = %71
  br label %92

92:                                               ; preds = %96, %91
  %93 = phi i64 [ 0, %91 ], [ %102, %96 ]
  %94 = phi i1 [ %73, %91 ], [ %101, %96 ]
  %95 = icmp slt i64 %93, %62
  br i1 %95, label %96, label %103

96:                                               ; preds = %92
  %97 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, 1
  %98 = getelementptr inbounds nuw i64, ptr %97, i64 %93
  %99 = load i64, ptr %98, align 4
  %100 = icmp ne i64 %99, %67
  %101 = and i1 %94, %100
  %102 = add i64 %93, 1
  br label %92

103:                                              ; preds = %92
  %104 = and i1 %94, %70
  %105 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, 1
  %106 = getelementptr inbounds nuw i1, ptr %105, i64 %62
  store i1 %104, ptr %106, align 1
  %107 = add i64 %62, 1
  br label %61

108:                                              ; preds = %61
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
