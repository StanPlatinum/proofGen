; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-linux-gnu -mcpu=corei7 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7 | FileCheck %s --check-prefixes=CHECK,X64

define i32 @mul_f(<4 x i8>* %A) {
; X86-LABEL: mul_f:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X86-NEXT:    pmaddwd %xmm0, %xmm0
; X86-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; X86-NEXT:    movd %xmm0, (%eax)
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: mul_f:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X64-NEXT:    pmaddwd %xmm0, %xmm0
; X64-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; X64-NEXT:    movd %xmm0, (%rax)
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
entry:
  %0 = load <4 x i8>, <4 x i8>* %A, align 8
  %mul = mul <4 x i8> %0, %0
  store <4 x i8> %mul, <4 x i8>* undef
  ret i32 0
}

define i32 @shuff_f(<4 x i8>* %A) {
; X86-LABEL: shuff_f:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    pmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X86-NEXT:    paddd %xmm0, %xmm0
; X86-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; X86-NEXT:    movd %xmm0, (%eax)
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: shuff_f:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pmovzxbd {{.*#+}} xmm0 = mem[0],zero,zero,zero,mem[1],zero,zero,zero,mem[2],zero,zero,zero,mem[3],zero,zero,zero
; X64-NEXT:    paddd %xmm0, %xmm0
; X64-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; X64-NEXT:    movd %xmm0, (%rax)
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
entry:
  %0 = load <4 x i8>, <4 x i8>* %A, align 8
  %add = add <4 x i8> %0, %0
  store <4 x i8> %add, <4 x i8>* undef
  ret i32 0
}

define <2 x float> @bitcast_widen(<4 x i32> %in) nounwind readnone {
; CHECK-LABEL: bitcast_widen:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ret{{[l|q]}}
entry:
 %x = shufflevector <4 x i32> %in, <4 x i32> undef, <2 x i32> <i32 0, i32 1>
 %y = bitcast <2 x i32> %x to <2 x float>
 ret <2 x float> %y
}
