; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; InstCombine should mark null-checked argument as nonnull at callsite
declare void @dummy(i32*, i32)

define void @test(i32* %a, i32 %b) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND1:%.*]] = icmp eq i32* %a, null
; CHECK-NEXT:    br i1 [[COND1]], label %dead, label %not_null
; CHECK:       not_null:
; CHECK-NEXT:    [[COND2:%.*]] = icmp eq i32 %b, 0
; CHECK-NEXT:    br i1 [[COND2]], label %dead, label %not_zero
; CHECK:       not_zero:
; CHECK-NEXT:    call void @dummy(i32* nonnull %a, i32 %b)
; CHECK-NEXT:    ret void
; CHECK:       dead:
; CHECK-NEXT:    unreachable
;
entry:
  %cond1 = icmp eq i32* %a, null
  br i1 %cond1, label %dead, label %not_null
not_null:
  %cond2 = icmp eq i32 %b, 0
  br i1 %cond2, label %dead, label %not_zero
not_zero:
  call void @dummy(i32* %a, i32 %b)
  ret void
dead:
  unreachable
}

; The nonnull attribute in the 'bar' declaration is 
; propagated to the parameters of the 'baz' callsite. 

declare void @bar(i8*, i8* nonnull)
declare void @baz(i8*, i8*)

define void @deduce_nonnull_from_another_call(i8* %a, i8* %b) {
; CHECK-LABEL: @deduce_nonnull_from_another_call(
; CHECK-NEXT:    call void @bar(i8* %a, i8* %b)
; CHECK-NEXT:    call void @baz(i8* nonnull %b, i8* nonnull %b)
; CHECK-NEXT:    ret void
;
  call void @bar(i8* %a, i8* %b)
  call void @baz(i8* %b, i8* %b)
  ret void
}

