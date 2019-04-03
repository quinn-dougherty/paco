Require Export Program.Basics. Open Scope program_scope.
Require Import paco8 pacotac.
Set Implicit Arguments.

Section Companion8.

Variable T0 : Type.
Variable T1 : forall (x0: @T0), Type.
Variable T2 : forall (x0: @T0) (x1: @T1 x0), Type.
Variable T3 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1), Type.
Variable T4 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2), Type.
Variable T5 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3), Type.
Variable T6 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4), Type.
Variable T7 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5), Type.

Local Notation rel := (rel8 T0 T1 T2 T3 T4 T5 T6 T7).

Section Companion8_main.

Variable gf: rel -> rel.
Hypothesis gf_mon: monotone8 gf.

(** 
  Bounded Compatibility, Companion & Guarded Companion
*)

Inductive pointwise_union (bnd: rel -> rel) (r: rel) e0 e1 e2 e3 e4 e5 e6 e7 : Prop :=
| pw_union_ d0 d1 d2 d3 d4 d5 d6 d7
            (IN: r d0 d1 d2 d3 d4 d5 d6 d7)
            (PTW: forall (s: rel), s d0 d1 d2 d3 d4 d5 d6 d7 -> bnd s e0 e1 e2 e3 e4 e5 e6 e7)
.

Structure compatible_bound8 (bnd: rel -> rel) : Prop :=
  cbound8_intro {
      cbound8_distr : forall r,
          bnd r <8= pointwise_union bnd r;
      cbound8_compat: forall r,
          bnd (gf r) <8= gf (bnd r);
      cbound8_bound: forall r,
          bnd (bnd r) <8= (bnd r \8/ gf (bnd r));
    }.

Variable bnd: rel -> rel.
Hypothesis bnd_compat : compatible_bound8 bnd.

Structure compatible8 (clo: rel -> rel) : Prop :=
  compat8_intro {
      compat8_mon: monotone8 clo;
      compat8_compat : forall r,
          clo (gf r) <8= gf (clo r);
      compat8_bound : forall r,
          bnd (clo r) <8= (bnd r \8/ gf (clo r))
    }.

Inductive cpn8 (r: rel) e0 e1 e2 e3 e4 e5 e6 e7 : Prop :=
| cpn8_intro
    clo
    (COM: compatible8 clo)
    (CLO: clo r e0 e1 e2 e3 e4 e5 e6 e7)
.

Definition fcpn8 := compose gf cpn8.

Lemma cbound8_union r1 r2 : bnd (r1 \8/ r2) <8= (bnd r1 \8/ bnd r2).
Proof.
  intros. eapply cbound8_distr in PR; [|apply bnd_compat].
  destruct PR. destruct IN.
  - left. apply PTW, H.
  - right. apply PTW, H.
Qed.

Lemma cbound8_mon: monotone8 bnd.
Proof.
  repeat intro.
  apply (cbound8_distr bnd_compat) in IN.
  destruct IN.
  apply PTW, LE, IN.
Qed.

Lemma cpn8_mon: monotone8 cpn8.
Proof.
  red. intros.
  destruct IN. exists clo.
  - apply COM.
  - eapply compat8_mon; [apply COM|apply CLO|apply LE].
Qed.

Lemma cpn8_compat: compatible8 cpn8.
Proof.
  econstructor; [apply cpn8_mon| |]; intros.
  - destruct PR; eapply gf_mon with (r:=clo r).
    + eapply (compat8_compat COM); apply CLO.
    + intros. econstructor; [apply COM|apply PR].
  - eapply (cbound8_distr bnd_compat) in PR.
    destruct PR. destruct IN.
    specialize (PTW (clo r) CLO).
    apply (compat8_bound COM) in PTW.
    destruct PTW.
    + left. apply H.
    + right. eapply gf_mon; [apply H|].
      intros. econstructor;[apply COM|apply PR].
Qed.

Lemma cpn8_greatest: forall clo (COM: compatible8 clo), clo <9= cpn8.
Proof. intros. econstructor;[apply COM|apply PR]. Qed.

Lemma cpn8_base: forall r, r <8= cpn8 r.
Proof.
  intros. exists id.
  - econstructor; repeat intro.
    + apply LE, IN.
    + apply PR0.
    + left. apply PR0.
  - apply PR.
Qed.

Lemma cpn8_bound : forall r, bnd r <8= cpn8 r.
Proof.
  intros. exists bnd.
  - econstructor; repeat intro.
    + eapply cbound8_mon. apply IN. apply LE.
    + apply (cbound8_compat bnd_compat), PR0.
    + apply (cbound8_bound bnd_compat), PR0.
  - apply PR.
Qed.

Lemma cpn8_cpn: forall r,
    cpn8 (cpn8 r) <8= cpn8 r.
Proof.
  intros. exists (compose cpn8 cpn8); [|apply PR].
  econstructor.
  - repeat intro. eapply cpn8_mon; [apply IN|].
    intros. eapply cpn8_mon; [apply PR0|apply LE].
  - intros. eapply (compat8_compat cpn8_compat).
    eapply cpn8_mon; [apply PR0|].
    intros. eapply (compat8_compat cpn8_compat), PR1.
  - intros. eapply (compat8_bound cpn8_compat) in PR0.
    destruct PR0; [|right; apply H].
    eapply (compat8_bound cpn8_compat) in H.
    destruct H; [left; apply H|].
    right. eapply gf_mon; [apply H|].
    intros. apply cpn8_base. apply PR0.
Qed.

Lemma fcpn8_mon: monotone8 fcpn8.
Proof.
  repeat intro. eapply gf_mon; [eapply IN|].
  intros. eapply cpn8_mon; [apply PR|apply LE].
Qed.

Lemma fcpn8_sound:
  paco8 fcpn8 bot8 <8= paco8 gf bot8.
Proof.
  intros.
  set (rclo := fix rclo clo n (r: rel) :=
         match n with
         | 0 => r
         | S n' => rclo clo n' r \8/ clo (rclo clo n' r)
         end).
  assert (RC: exists n, rclo cpn8 n (paco8 fcpn8 bot8) x0 x1 x2 x3 x4 x5 x6 x7) by (exists 0; apply PR); clear PR.
  
  cut (forall n, rclo cpn8 n (paco8 fcpn8 bot8) <8= gf (rclo cpn8 (S n) (paco8 fcpn8 bot8))).
  { intro X. revert x0 x1 x2 x3 x4 x5 x6 x7 RC; pcofix CIH; intros.
    pfold. eapply gf_mon.
    - apply X. apply RC.
    - intros. right. eapply CIH. apply PR.
  }

  induction n; intros.
  - eapply gf_mon.
    + _punfold PR; [apply PR|apply fcpn8_mon].
    + intros. right. eapply cpn8_mon; [apply PR0|].
      intros. pclearbot. apply PR1.
  - destruct PR.
    + eapply gf_mon; [eapply IHn, H|]. intros. left. apply PR.
    + eapply gf_mon.
      * eapply (compat8_compat cpn8_compat).
        eapply (compat8_mon cpn8_compat); [apply H|apply IHn].
      * intros. econstructor 2. apply PR.
Qed.

(** 
  Recursive Closure & Weak Compatibility
*)

Inductive rclo8 (clo: rel->rel) (r: rel): rel :=
| rclo8_base
    e0 e1 e2 e3 e4 e5 e6 e7
    (R: r e0 e1 e2 e3 e4 e5 e6 e7):
    @rclo8 clo r e0 e1 e2 e3 e4 e5 e6 e7
| rclo8_clo'
    r' e0 e1 e2 e3 e4 e5 e6 e7
    (R': r' <8= rclo8 clo r)
    (CLOR': clo r' e0 e1 e2 e3 e4 e5 e6 e7):
    @rclo8 clo r e0 e1 e2 e3 e4 e5 e6 e7
| rclo8_step'
    r' e0 e1 e2 e3 e4 e5 e6 e7
    (R': r' <8= rclo8 clo r)
    (CLOR': @gf r' e0 e1 e2 e3 e4 e5 e6 e7):
    @rclo8 clo r e0 e1 e2 e3 e4 e5 e6 e7
| rclo8_cpn'
    r' e0 e1 e2 e3 e4 e5 e6 e7
    (R': r' <8= rclo8 clo r)
    (CLOR': @cpn8 r' e0 e1 e2 e3 e4 e5 e6 e7):
    @rclo8 clo r e0 e1 e2 e3 e4 e5 e6 e7
.

Structure wcompatible8 (clo: rel -> rel) : Prop :=
  wcompat8_intro {
      wcompat8_mon: monotone8 clo;
      wcompat8_wcompat: forall r,
          clo (gf r) <8= gf (rclo8 clo r);
      wcompat8_bound : forall r,
          bnd (clo r) <8= (bnd r \8/ gf (rclo8 clo r))
    }.

Lemma rclo8_mon_gen clo clo' r r' e0 e1 e2 e3 e4 e5 e6 e7
      (IN: @rclo8 clo r e0 e1 e2 e3 e4 e5 e6 e7)
      (LEclo: clo <9= clo')
      (LEr: r <8= r') :
  @rclo8 clo' r' e0 e1 e2 e3 e4 e5 e6 e7.
Proof.
  induction IN; intros.
  - econstructor 1. apply LEr, R.
  - econstructor 2; [intros; eapply H, PR|apply LEclo, CLOR'].
  - econstructor 3; [intros; eapply H, PR|apply CLOR'].
  - econstructor 4; [intros; eapply H, PR|].
    eapply cpn8_mon; [apply CLOR'|].
    intros. apply PR.
Qed.

Lemma rclo8_mon clo:
  monotone8 (rclo8 clo).
Proof.
  repeat intro. eapply rclo8_mon_gen; [apply IN|intros; apply PR|apply LE].
Qed.

Lemma rclo8_clo clo r:
  clo (rclo8 clo r) <8= rclo8 clo r.
Proof.
  intros. econstructor 2; [|apply PR]. 
  intros. apply PR0.
Qed.

Lemma rclo8_step clo r:
  gf (rclo8 clo r) <8= rclo8 clo r.
Proof.
  intros. econstructor 3; [|apply PR].
  intros. apply PR0.
Qed.

Lemma rclo8_cpn clo r:
  cpn8 (rclo8 clo r) <8= rclo8 clo r.
Proof.
  intros. econstructor 4; [|apply PR]. 
  intros. apply PR0.
Qed.

Lemma rclo8_mult clo r:
  rclo8 clo (rclo8 clo r) <8= rclo8 clo r.
Proof.
  intros. induction PR.
  - apply R.
  - econstructor 2; [eapply H | eapply CLOR'].
  - econstructor 3; [eapply H | eapply CLOR'].
  - econstructor 4; [eapply H | eapply CLOR'].
Qed.

Lemma rclo8_compose clo r:
  rclo8 (rclo8 clo) r <8= rclo8 clo r.
Proof.
  intros. induction PR.
  - apply rclo8_base, R.
  - apply rclo8_mult.
    eapply rclo8_mon; [apply CLOR'|apply H].
  - apply rclo8_step.
    eapply gf_mon; [apply CLOR'|apply H].
  - apply rclo8_cpn.
    eapply cpn8_mon; [apply CLOR'|apply H].
Qed.

Lemma wcompat8_compat
      clo (WCOM: wcompatible8 clo):
  compatible8 (rclo8 clo).
Proof.
  econstructor; [eapply rclo8_mon| |]; intros.
  - induction PR; intros.
    + eapply gf_mon; [apply R|]. intros.
      apply rclo8_base. apply PR.
    + eapply gf_mon.
      * eapply (wcompat8_wcompat WCOM).
        eapply (wcompat8_mon WCOM); [apply CLOR'|apply H].
      * intros. apply rclo8_mult, PR.
    + eapply gf_mon; [apply CLOR'|].
      intros. apply H in PR. apply rclo8_step, PR.
    + eapply gf_mon; [|intros; apply rclo8_cpn, PR].
      apply (compat8_compat cpn8_compat).
      eapply cpn8_mon; [apply CLOR'|apply H].
  - eapply (cbound8_distr bnd_compat) in PR.
    destruct PR. revert x0 x1 x2 x3 x4 x5 x6 x7 PTW.
    induction IN; intros.
    + left. apply PTW, R.
    + specialize (PTW _ CLOR').
      eapply (wcompat8_bound WCOM) in PTW.
      destruct PTW as [PTW|PTW].
      * eapply (cbound8_distr bnd_compat) in PTW.
        destruct PTW.
        eapply H; [apply IN | apply PTW].
      * right. eapply gf_mon; [apply PTW|].
        intros. apply rclo8_mult.
        eapply rclo8_mon, R'. apply PR.
    + specialize (PTW _ CLOR').
      eapply (cbound8_compat bnd_compat) in PTW.
      right. eapply gf_mon. apply PTW. intros.
      eapply (cbound8_distr bnd_compat) in PR.
      destruct PR.
      eapply H in IN; [|apply PTW0].
      destruct IN.
      * apply rclo8_cpn, cpn8_bound.
        eapply cbound8_mon. apply H0. apply rclo8_base.
      * apply rclo8_step. apply H0.
    + specialize (PTW _ CLOR').
      apply (compat8_bound cpn8_compat) in PTW.
      destruct PTW as [PTW|PTW].
      * eapply (cbound8_distr bnd_compat) in PTW.
        destruct PTW.
        eapply H; [apply IN | apply PTW].
      * right. eapply gf_mon; [apply PTW|].
        intros. apply rclo8_cpn.
        eapply cpn8_mon; [apply PR|].
        intros. apply R', PR0.
Qed.

Lemma wcompat8_sound clo (WCOM: wcompatible8 clo):
  clo <9= cpn8.
Proof.
  intros. exists (rclo8 clo).
  - apply wcompat8_compat, WCOM.
  - apply rclo8_clo.
    eapply (wcompat8_mon WCOM); [apply PR|].
    intros. apply rclo8_base, PR0.
Qed.

(** 
  Lemmas for tactics
*)

Lemma cpn8_from_upaco r:
  upaco8 fcpn8 r <8= cpn8 r.
Proof.
  intros. destruct PR; [| apply cpn8_base, H].
  exists (rclo8 (paco8 fcpn8)).
  - apply wcompat8_compat.
    econstructor; [apply paco8_mon| |].
    + intros. _punfold PR; [|apply fcpn8_mon].
      eapply gf_mon; [apply PR|].
      intros. apply rclo8_cpn.
      eapply cpn8_mon; [apply PR0|].
      intros. destruct PR1.
      * apply rclo8_clo.
        eapply paco8_mon; [apply H0|].
        intros. apply rclo8_step.
        eapply gf_mon; [apply PR1|].
        intros. apply rclo8_base, PR2.
      * apply rclo8_step.
        eapply gf_mon; [apply H0|].
        intros. apply rclo8_base, PR1.
    + intros. right.
      eapply gf_mon, rclo8_cpn.
      eapply gf_mon, cpn8_bound.
      apply (cbound8_compat bnd_compat).
      eapply cbound8_mon. apply PR.
      intros. _punfold PR0; [|apply fcpn8_mon].
      eapply gf_mon. apply PR0.
      intros. apply rclo8_cpn.
      eapply cpn8_mon. apply PR1.
      intros. destruct PR2.
      * apply rclo8_clo.
        eapply paco8_mon. apply H0.
        intros. apply rclo8_base. apply PR2.
      * apply rclo8_base. apply H0.
  - apply rclo8_clo.
    eapply paco8_mon; [apply H|].
    intros. apply rclo8_base, PR.
Qed.

Lemma cpn8_from_paco r:
  paco8 fcpn8 r <8= cpn8 r.
Proof. intros. apply cpn8_from_upaco. left. apply PR. Qed.

Lemma fcpn8_from_paco r:
  paco8 fcpn8 r <8= fcpn8 r.
Proof.
  intros. _punfold PR; [|apply fcpn8_mon].
  eapply gf_mon; [apply PR|].
  intros. apply cpn8_cpn.
  eapply cpn8_mon; [apply PR0|].
  apply cpn8_from_upaco.
Qed.

Lemma fcpn8_to_paco r:
  fcpn8 r <8= paco8 fcpn8 r.
Proof.
  intros. pfold. eapply fcpn8_mon; [apply PR|].
  intros. right. apply PR0.
Qed.  

Lemma cpn8_complete:
  paco8 gf bot8 <8= cpn8 bot8.
Proof.
  intros. apply cpn8_from_paco.
  eapply paco8_mon_gen.
  - apply PR.
  - intros. eapply gf_mon; [apply PR0|apply cpn8_base].
  - intros. apply PR0.
Qed.

Lemma cpn8_init:
  cpn8 bot8 <8= paco8 gf bot8.
Proof.
  intros. apply fcpn8_sound, fcpn8_to_paco, (compat8_compat cpn8_compat).
  eapply cpn8_mon; [apply PR|contradiction].
Qed.

Lemma cpn8_clo
      r clo (LE: clo <9= cpn8):
  clo (cpn8 r) <8= cpn8 r.
Proof.
  intros. apply cpn8_cpn, LE, PR.
Qed.

Lemma cpn8_unfold:
  cpn8 bot8 <8= fcpn8 bot8.
Proof.
  intros. apply cpn8_init in PR. punfold PR.
  eapply gf_mon; [apply PR|].
  intros. pclearbot. apply cpn8_complete, PR0.
Qed.

Lemma cpn8_unfold_bound r
      (BASE: forall r, r <8= bnd r):
  cpn8 r <8= (bnd r \8/ fcpn8 r).
Proof.
  intros. apply BASE in PR.
  eapply compat8_bound in PR.
  - apply PR.
  - apply cpn8_compat.
Qed.

Lemma cpn8_step r:
  fcpn8 r <8= cpn8 r.
Proof.
  intros. eapply cpn8_clo, PR.
  intros. eapply wcompat8_sound, PR0.
  econstructor; [apply gf_mon| |].
  - intros. eapply gf_mon; [apply PR1|].
    intros. apply rclo8_step.
    eapply gf_mon; [apply PR2|].
    intros. apply rclo8_base, PR3.
  - intros. apply (cbound8_compat bnd_compat) in PR1.
    right. eapply gf_mon. apply PR1.
    intros. apply rclo8_cpn, cpn8_bound.
    eapply cbound8_mon. apply PR2.
    intros. apply rclo8_base, PR3.
Qed.

Lemma fcpn8_clo
      r clo (LE: clo <9= cpn8):
  clo (fcpn8 r) <8= fcpn8 r.
Proof.
  intros. apply LE, (compat8_compat cpn8_compat) in PR.
  eapply gf_mon; [apply PR|].
  intros. apply cpn8_cpn, PR0.
Qed.

Lemma cpn8_final: forall r, upaco8 gf r <8= cpn8 r.
Proof.
  intros. eapply cpn8_from_upaco.
  intros. eapply upaco8_mon_gen; [apply PR| |intros; apply PR0].
  intros. eapply gf_mon; [apply PR0|].
  intros. apply cpn8_base, PR1.
Qed.

Lemma fcpn8_final: forall r, paco8 gf r <8= fcpn8 r.
Proof.
  intros. _punfold PR; [|apply gf_mon].
  eapply gf_mon; [apply PR | apply cpn8_final].
Qed.

Lemma cpn8_algebra r :
  r <8= gf r -> r <8= cpn8 bot8.
Proof.
  intros. apply cpn8_final. left.
  revert x0 x1 x2 x3 x4 x5 x6 x7 PR.
  pcofix CIH. intros.
  pfold. eapply gf_mon. apply H, PR.
  intros. right. apply CIH, PR0.
Qed.

End Companion8_main.

Lemma cbound8_bot gf:
  compatible_bound8 gf bot9.
Proof.
  econstructor; intros; contradiction.
Qed.

Lemma cpn8_mon_bot (gf gf': rel -> rel) bnd bnd' e0 e1 e2 e3 e4 e5 e6 e7 r
      (IN: @cpn8 gf bnd bot8 e0 e1 e2 e3 e4 e5 e6 e7)
      (MON: monotone8 gf)
      (MON': monotone8 gf')
      (BASE: compatible_bound8 gf bnd)
      (BASE': compatible_bound8 gf' bnd')
      (LE: gf <9= gf'):
  @cpn8 gf' bnd' r e0 e1 e2 e3 e4 e5 e6 e7.
Proof.
  apply cpn8_init in IN; [|apply MON|apply BASE].
  apply cpn8_final; [apply MON'|apply BASE'|].
  left. eapply paco8_mon_gen; [apply IN| apply LE| contradiction].
Qed.

Lemma fcpn8_mon_bot (gf gf': rel -> rel) bnd bnd' e0 e1 e2 e3 e4 e5 e6 e7 r
      (IN: @fcpn8 gf bnd bot8 e0 e1 e2 e3 e4 e5 e6 e7)
      (MON: monotone8 gf)
      (MON': monotone8 gf')
      (BASE: compatible_bound8 gf bnd)
      (BASE': compatible_bound8 gf' bnd')
      (LE: gf <9= gf'):
  @fcpn8 gf' bnd' r e0 e1 e2 e3 e4 e5 e6 e7.
Proof.
  apply LE. eapply MON. apply IN.
  intros. eapply cpn8_mon_bot; eassumption.
Qed.

End Companion8.

Hint Unfold fcpn8 : paco.
Hint Resolve cpn8_base : paco.
Hint Resolve cpn8_step : paco.
Hint Resolve cbound8_bot : paco.

Hint Constructors rclo8 : rclo.
Hint Resolve rclo8_clo rclo8_step rclo8_cpn : rclo.

