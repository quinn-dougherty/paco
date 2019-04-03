Require Export Program.Basics. Open Scope program_scope.
Require Import paco10 pacotac.
Set Implicit Arguments.

Section Companion10.

Variable T0 : Type.
Variable T1 : forall (x0: @T0), Type.
Variable T2 : forall (x0: @T0) (x1: @T1 x0), Type.
Variable T3 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1), Type.
Variable T4 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2), Type.
Variable T5 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3), Type.
Variable T6 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4), Type.
Variable T7 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5), Type.
Variable T8 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5) (x7: @T7 x0 x1 x2 x3 x4 x5 x6), Type.
Variable T9 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5) (x7: @T7 x0 x1 x2 x3 x4 x5 x6) (x8: @T8 x0 x1 x2 x3 x4 x5 x6 x7), Type.

Local Notation rel := (rel10 T0 T1 T2 T3 T4 T5 T6 T7 T8 T9).

Section Companion10_main.

Variable gf: rel -> rel.
Hypothesis gf_mon: monotone10 gf.

(** 
  Bounded Compatibility, Companion & Guarded Companion
*)

Inductive pointwise_union (bnd: rel -> rel) (r: rel) e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 : Prop :=
| pw_union_ d0 d1 d2 d3 d4 d5 d6 d7 d8 d9
            (IN: r d0 d1 d2 d3 d4 d5 d6 d7 d8 d9)
            (PTW: forall (s: rel), s d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 -> bnd s e0 e1 e2 e3 e4 e5 e6 e7 e8 e9)
.

Structure compatible_bound10 (bnd: rel -> rel) : Prop :=
  cbound10_intro {
      cbound10_distr : forall r,
          bnd r <10= pointwise_union bnd r;
      cbound10_compat: forall r,
          bnd (gf r) <10= gf (bnd r);
      cbound10_bound: forall r,
          bnd (bnd r) <10= (bnd r \10/ gf (bnd r));
    }.

Variable bnd: rel -> rel.
Hypothesis bnd_compat : compatible_bound10 bnd.

Structure compatible10 (clo: rel -> rel) : Prop :=
  compat10_intro {
      compat10_mon: monotone10 clo;
      compat10_compat : forall r,
          clo (gf r) <10= gf (clo r);
      compat10_bound : forall r,
          bnd (clo r) <10= (bnd r \10/ gf (clo r))
    }.

Inductive cpn10 (r: rel) e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 : Prop :=
| cpn10_intro
    clo
    (COM: compatible10 clo)
    (CLO: clo r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9)
.

Definition fcpn10 := compose gf cpn10.

Lemma cbound10_union r1 r2 : bnd (r1 \10/ r2) <10= (bnd r1 \10/ bnd r2).
Proof.
  intros. eapply cbound10_distr in PR; [|apply bnd_compat].
  destruct PR. destruct IN.
  - left. apply PTW, H.
  - right. apply PTW, H.
Qed.

Lemma cbound10_mon: monotone10 bnd.
Proof.
  repeat intro.
  apply (cbound10_distr bnd_compat) in IN.
  destruct IN.
  apply PTW, LE, IN.
Qed.

Lemma cpn10_mon: monotone10 cpn10.
Proof.
  red. intros.
  destruct IN. exists clo.
  - apply COM.
  - eapply compat10_mon; [apply COM|apply CLO|apply LE].
Qed.

Lemma cpn10_compat: compatible10 cpn10.
Proof.
  econstructor; [apply cpn10_mon| |]; intros.
  - destruct PR; eapply gf_mon with (r:=clo r).
    + eapply (compat10_compat COM); apply CLO.
    + intros. econstructor; [apply COM|apply PR].
  - eapply (cbound10_distr bnd_compat) in PR.
    destruct PR. destruct IN.
    specialize (PTW (clo r) CLO).
    apply (compat10_bound COM) in PTW.
    destruct PTW.
    + left. apply H.
    + right. eapply gf_mon; [apply H|].
      intros. econstructor;[apply COM|apply PR].
Qed.

Lemma cpn10_greatest: forall clo (COM: compatible10 clo), clo <11= cpn10.
Proof. intros. econstructor;[apply COM|apply PR]. Qed.

Lemma cpn10_base: forall r, r <10= cpn10 r.
Proof.
  intros. exists id.
  - econstructor; repeat intro.
    + apply LE, IN.
    + apply PR0.
    + left. apply PR0.
  - apply PR.
Qed.

Lemma cpn10_bound : forall r, bnd r <10= cpn10 r.
Proof.
  intros. exists bnd.
  - econstructor; repeat intro.
    + eapply cbound10_mon. apply IN. apply LE.
    + apply (cbound10_compat bnd_compat), PR0.
    + apply (cbound10_bound bnd_compat), PR0.
  - apply PR.
Qed.

Lemma cpn10_cpn: forall r,
    cpn10 (cpn10 r) <10= cpn10 r.
Proof.
  intros. exists (compose cpn10 cpn10); [|apply PR].
  econstructor.
  - repeat intro. eapply cpn10_mon; [apply IN|].
    intros. eapply cpn10_mon; [apply PR0|apply LE].
  - intros. eapply (compat10_compat cpn10_compat).
    eapply cpn10_mon; [apply PR0|].
    intros. eapply (compat10_compat cpn10_compat), PR1.
  - intros. eapply (compat10_bound cpn10_compat) in PR0.
    destruct PR0; [|right; apply H].
    eapply (compat10_bound cpn10_compat) in H.
    destruct H; [left; apply H|].
    right. eapply gf_mon; [apply H|].
    intros. apply cpn10_base. apply PR0.
Qed.

Lemma fcpn10_mon: monotone10 fcpn10.
Proof.
  repeat intro. eapply gf_mon; [eapply IN|].
  intros. eapply cpn10_mon; [apply PR|apply LE].
Qed.

Lemma fcpn10_sound:
  paco10 fcpn10 bot10 <10= paco10 gf bot10.
Proof.
  intros.
  set (rclo := fix rclo clo n (r: rel) :=
         match n with
         | 0 => r
         | S n' => rclo clo n' r \10/ clo (rclo clo n' r)
         end).
  assert (RC: exists n, rclo cpn10 n (paco10 fcpn10 bot10) x0 x1 x2 x3 x4 x5 x6 x7 x8 x9) by (exists 0; apply PR); clear PR.
  
  cut (forall n, rclo cpn10 n (paco10 fcpn10 bot10) <10= gf (rclo cpn10 (S n) (paco10 fcpn10 bot10))).
  { intro X. revert x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 RC; pcofix CIH; intros.
    pfold. eapply gf_mon.
    - apply X. apply RC.
    - intros. right. eapply CIH. apply PR.
  }

  induction n; intros.
  - eapply gf_mon.
    + _punfold PR; [apply PR|apply fcpn10_mon].
    + intros. right. eapply cpn10_mon; [apply PR0|].
      intros. pclearbot. apply PR1.
  - destruct PR.
    + eapply gf_mon; [eapply IHn, H|]. intros. left. apply PR.
    + eapply gf_mon.
      * eapply (compat10_compat cpn10_compat).
        eapply (compat10_mon cpn10_compat); [apply H|apply IHn].
      * intros. econstructor 2. apply PR.
Qed.

(** 
  Recursive Closure & Weak Compatibility
*)

Inductive rclo10 (clo: rel->rel) (r: rel): rel :=
| rclo10_base
    e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
    (R: r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9):
    @rclo10 clo r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
| rclo10_clo'
    r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
    (R': r' <10= rclo10 clo r)
    (CLOR': clo r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9):
    @rclo10 clo r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
| rclo10_step'
    r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
    (R': r' <10= rclo10 clo r)
    (CLOR': @gf r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9):
    @rclo10 clo r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
| rclo10_cpn'
    r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
    (R': r' <10= rclo10 clo r)
    (CLOR': @cpn10 r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9):
    @rclo10 clo r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
.

Structure wcompatible10 (clo: rel -> rel) : Prop :=
  wcompat10_intro {
      wcompat10_mon: monotone10 clo;
      wcompat10_wcompat: forall r,
          clo (gf r) <10= gf (rclo10 clo r);
      wcompat10_bound : forall r,
          bnd (clo r) <10= (bnd r \10/ gf (rclo10 clo r))
    }.

Lemma rclo10_mon_gen clo clo' r r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9
      (IN: @rclo10 clo r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9)
      (LEclo: clo <11= clo')
      (LEr: r <10= r') :
  @rclo10 clo' r' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9.
Proof.
  induction IN; intros.
  - econstructor 1. apply LEr, R.
  - econstructor 2; [intros; eapply H, PR|apply LEclo, CLOR'].
  - econstructor 3; [intros; eapply H, PR|apply CLOR'].
  - econstructor 4; [intros; eapply H, PR|].
    eapply cpn10_mon; [apply CLOR'|].
    intros. apply PR.
Qed.

Lemma rclo10_mon clo:
  monotone10 (rclo10 clo).
Proof.
  repeat intro. eapply rclo10_mon_gen; [apply IN|intros; apply PR|apply LE].
Qed.

Lemma rclo10_clo clo r:
  clo (rclo10 clo r) <10= rclo10 clo r.
Proof.
  intros. econstructor 2; [|apply PR]. 
  intros. apply PR0.
Qed.

Lemma rclo10_step clo r:
  gf (rclo10 clo r) <10= rclo10 clo r.
Proof.
  intros. econstructor 3; [|apply PR].
  intros. apply PR0.
Qed.

Lemma rclo10_cpn clo r:
  cpn10 (rclo10 clo r) <10= rclo10 clo r.
Proof.
  intros. econstructor 4; [|apply PR]. 
  intros. apply PR0.
Qed.

Lemma rclo10_mult clo r:
  rclo10 clo (rclo10 clo r) <10= rclo10 clo r.
Proof.
  intros. induction PR.
  - apply R.
  - econstructor 2; [eapply H | eapply CLOR'].
  - econstructor 3; [eapply H | eapply CLOR'].
  - econstructor 4; [eapply H | eapply CLOR'].
Qed.

Lemma rclo10_compose clo r:
  rclo10 (rclo10 clo) r <10= rclo10 clo r.
Proof.
  intros. induction PR.
  - apply rclo10_base, R.
  - apply rclo10_mult.
    eapply rclo10_mon; [apply CLOR'|apply H].
  - apply rclo10_step.
    eapply gf_mon; [apply CLOR'|apply H].
  - apply rclo10_cpn.
    eapply cpn10_mon; [apply CLOR'|apply H].
Qed.

Lemma wcompat10_compat
      clo (WCOM: wcompatible10 clo):
  compatible10 (rclo10 clo).
Proof.
  econstructor; [eapply rclo10_mon| |]; intros.
  - induction PR; intros.
    + eapply gf_mon; [apply R|]. intros.
      apply rclo10_base. apply PR.
    + eapply gf_mon.
      * eapply (wcompat10_wcompat WCOM).
        eapply (wcompat10_mon WCOM); [apply CLOR'|apply H].
      * intros. apply rclo10_mult, PR.
    + eapply gf_mon; [apply CLOR'|].
      intros. apply H in PR. apply rclo10_step, PR.
    + eapply gf_mon; [|intros; apply rclo10_cpn, PR].
      apply (compat10_compat cpn10_compat).
      eapply cpn10_mon; [apply CLOR'|apply H].
  - eapply (cbound10_distr bnd_compat) in PR.
    destruct PR. revert x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 PTW.
    induction IN; intros.
    + left. apply PTW, R.
    + specialize (PTW _ CLOR').
      eapply (wcompat10_bound WCOM) in PTW.
      destruct PTW as [PTW|PTW].
      * eapply (cbound10_distr bnd_compat) in PTW.
        destruct PTW.
        eapply H; [apply IN | apply PTW].
      * right. eapply gf_mon; [apply PTW|].
        intros. apply rclo10_mult.
        eapply rclo10_mon, R'. apply PR.
    + specialize (PTW _ CLOR').
      eapply (cbound10_compat bnd_compat) in PTW.
      right. eapply gf_mon. apply PTW. intros.
      eapply (cbound10_distr bnd_compat) in PR.
      destruct PR.
      eapply H in IN; [|apply PTW0].
      destruct IN.
      * apply rclo10_cpn, cpn10_bound.
        eapply cbound10_mon. apply H0. apply rclo10_base.
      * apply rclo10_step. apply H0.
    + specialize (PTW _ CLOR').
      apply (compat10_bound cpn10_compat) in PTW.
      destruct PTW as [PTW|PTW].
      * eapply (cbound10_distr bnd_compat) in PTW.
        destruct PTW.
        eapply H; [apply IN | apply PTW].
      * right. eapply gf_mon; [apply PTW|].
        intros. apply rclo10_cpn.
        eapply cpn10_mon; [apply PR|].
        intros. apply R', PR0.
Qed.

Lemma wcompat10_sound clo (WCOM: wcompatible10 clo):
  clo <11= cpn10.
Proof.
  intros. exists (rclo10 clo).
  - apply wcompat10_compat, WCOM.
  - apply rclo10_clo.
    eapply (wcompat10_mon WCOM); [apply PR|].
    intros. apply rclo10_base, PR0.
Qed.

(** 
  Lemmas for tactics
*)

Lemma cpn10_from_upaco r:
  upaco10 fcpn10 r <10= cpn10 r.
Proof.
  intros. destruct PR; [| apply cpn10_base, H].
  exists (rclo10 (paco10 fcpn10)).
  - apply wcompat10_compat.
    econstructor; [apply paco10_mon| |].
    + intros. _punfold PR; [|apply fcpn10_mon].
      eapply gf_mon; [apply PR|].
      intros. apply rclo10_cpn.
      eapply cpn10_mon; [apply PR0|].
      intros. destruct PR1.
      * apply rclo10_clo.
        eapply paco10_mon; [apply H0|].
        intros. apply rclo10_step.
        eapply gf_mon; [apply PR1|].
        intros. apply rclo10_base, PR2.
      * apply rclo10_step.
        eapply gf_mon; [apply H0|].
        intros. apply rclo10_base, PR1.
    + intros. right.
      eapply gf_mon, rclo10_cpn.
      eapply gf_mon, cpn10_bound.
      apply (cbound10_compat bnd_compat).
      eapply cbound10_mon. apply PR.
      intros. _punfold PR0; [|apply fcpn10_mon].
      eapply gf_mon. apply PR0.
      intros. apply rclo10_cpn.
      eapply cpn10_mon. apply PR1.
      intros. destruct PR2.
      * apply rclo10_clo.
        eapply paco10_mon. apply H0.
        intros. apply rclo10_base. apply PR2.
      * apply rclo10_base. apply H0.
  - apply rclo10_clo.
    eapply paco10_mon; [apply H|].
    intros. apply rclo10_base, PR.
Qed.

Lemma cpn10_from_paco r:
  paco10 fcpn10 r <10= cpn10 r.
Proof. intros. apply cpn10_from_upaco. left. apply PR. Qed.

Lemma fcpn10_from_paco r:
  paco10 fcpn10 r <10= fcpn10 r.
Proof.
  intros. _punfold PR; [|apply fcpn10_mon].
  eapply gf_mon; [apply PR|].
  intros. apply cpn10_cpn.
  eapply cpn10_mon; [apply PR0|].
  apply cpn10_from_upaco.
Qed.

Lemma fcpn10_to_paco r:
  fcpn10 r <10= paco10 fcpn10 r.
Proof.
  intros. pfold. eapply fcpn10_mon; [apply PR|].
  intros. right. apply PR0.
Qed.  

Lemma cpn10_complete:
  paco10 gf bot10 <10= cpn10 bot10.
Proof.
  intros. apply cpn10_from_paco.
  eapply paco10_mon_gen.
  - apply PR.
  - intros. eapply gf_mon; [apply PR0|apply cpn10_base].
  - intros. apply PR0.
Qed.

Lemma cpn10_init:
  cpn10 bot10 <10= paco10 gf bot10.
Proof.
  intros. apply fcpn10_sound, fcpn10_to_paco, (compat10_compat cpn10_compat).
  eapply cpn10_mon; [apply PR|contradiction].
Qed.

Lemma cpn10_clo
      r clo (LE: clo <11= cpn10):
  clo (cpn10 r) <10= cpn10 r.
Proof.
  intros. apply cpn10_cpn, LE, PR.
Qed.

Lemma cpn10_unfold:
  cpn10 bot10 <10= fcpn10 bot10.
Proof.
  intros. apply cpn10_init in PR. punfold PR.
  eapply gf_mon; [apply PR|].
  intros. pclearbot. apply cpn10_complete, PR0.
Qed.

Lemma cpn10_unfold_bound r
      (BASE: forall r, r <10= bnd r):
  cpn10 r <10= (bnd r \10/ fcpn10 r).
Proof.
  intros. apply BASE in PR.
  eapply compat10_bound in PR.
  - apply PR.
  - apply cpn10_compat.
Qed.

Lemma cpn10_step r:
  fcpn10 r <10= cpn10 r.
Proof.
  intros. eapply cpn10_clo, PR.
  intros. eapply wcompat10_sound, PR0.
  econstructor; [apply gf_mon| |].
  - intros. eapply gf_mon; [apply PR1|].
    intros. apply rclo10_step.
    eapply gf_mon; [apply PR2|].
    intros. apply rclo10_base, PR3.
  - intros. apply (cbound10_compat bnd_compat) in PR1.
    right. eapply gf_mon. apply PR1.
    intros. apply rclo10_cpn, cpn10_bound.
    eapply cbound10_mon. apply PR2.
    intros. apply rclo10_base, PR3.
Qed.

Lemma fcpn10_clo
      r clo (LE: clo <11= cpn10):
  clo (fcpn10 r) <10= fcpn10 r.
Proof.
  intros. apply LE, (compat10_compat cpn10_compat) in PR.
  eapply gf_mon; [apply PR|].
  intros. apply cpn10_cpn, PR0.
Qed.

Lemma cpn10_final: forall r, upaco10 gf r <10= cpn10 r.
Proof.
  intros. eapply cpn10_from_upaco.
  intros. eapply upaco10_mon_gen; [apply PR| |intros; apply PR0].
  intros. eapply gf_mon; [apply PR0|].
  intros. apply cpn10_base, PR1.
Qed.

Lemma fcpn10_final: forall r, paco10 gf r <10= fcpn10 r.
Proof.
  intros. _punfold PR; [|apply gf_mon].
  eapply gf_mon; [apply PR | apply cpn10_final].
Qed.

Lemma cpn10_algebra r :
  r <10= gf r -> r <10= cpn10 bot10.
Proof.
  intros. apply cpn10_final. left.
  revert x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 PR.
  pcofix CIH. intros.
  pfold. eapply gf_mon. apply H, PR.
  intros. right. apply CIH, PR0.
Qed.

End Companion10_main.

Lemma cbound10_bot gf:
  compatible_bound10 gf bot11.
Proof.
  econstructor; intros; contradiction.
Qed.

Lemma cpn10_mon_bot (gf gf': rel -> rel) bnd bnd' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 r
      (IN: @cpn10 gf bnd bot10 e0 e1 e2 e3 e4 e5 e6 e7 e8 e9)
      (MON: monotone10 gf)
      (MON': monotone10 gf')
      (BASE: compatible_bound10 gf bnd)
      (BASE': compatible_bound10 gf' bnd')
      (LE: gf <11= gf'):
  @cpn10 gf' bnd' r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9.
Proof.
  apply cpn10_init in IN; [|apply MON|apply BASE].
  apply cpn10_final; [apply MON'|apply BASE'|].
  left. eapply paco10_mon_gen; [apply IN| apply LE| contradiction].
Qed.

Lemma fcpn10_mon_bot (gf gf': rel -> rel) bnd bnd' e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 r
      (IN: @fcpn10 gf bnd bot10 e0 e1 e2 e3 e4 e5 e6 e7 e8 e9)
      (MON: monotone10 gf)
      (MON': monotone10 gf')
      (BASE: compatible_bound10 gf bnd)
      (BASE': compatible_bound10 gf' bnd')
      (LE: gf <11= gf'):
  @fcpn10 gf' bnd' r e0 e1 e2 e3 e4 e5 e6 e7 e8 e9.
Proof.
  apply LE. eapply MON. apply IN.
  intros. eapply cpn10_mon_bot; eassumption.
Qed.

End Companion10.

Hint Unfold fcpn10 : paco.
Hint Resolve cpn10_base : paco.
Hint Resolve cpn10_step : paco.
Hint Resolve cbound10_bot : paco.

Hint Constructors rclo10 : rclo.
Hint Resolve rclo10_clo rclo10_step rclo10_cpn : rclo.

