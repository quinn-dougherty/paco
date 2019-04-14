Require Export Program.Basics. Open Scope program_scope.
Require Import paco9 pacotac cpn9.
Set Implicit Arguments.

Section CompatiblePaco9.

Variable T0 : Type.
Variable T1 : forall (x0: @T0), Type.
Variable T2 : forall (x0: @T0) (x1: @T1 x0), Type.
Variable T3 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1), Type.
Variable T4 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2), Type.
Variable T5 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3), Type.
Variable T6 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4), Type.
Variable T7 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5), Type.
Variable T8 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5) (x7: @T7 x0 x1 x2 x3 x4 x5 x6), Type.

Local Notation rel := (rel9 T0 T1 T2 T3 T4 T5 T6 T7 T8).

Section CompatiblePaco9_main.

Variable gf: rel -> rel.
Hypothesis gf_mon: monotone9 gf.

Variable clo : rel -> rel.
Hypothesis clo_compat: compatible9 gf clo.

Inductive cpaco9 r rg x0 x1 x2 x3 x4 x5 x6 x7 x8 : Prop :=
| cpaco9_intro (IN: rclo9 clo (r \9/ paco9 (compose gf (rclo9 clo)) rg) x0 x1 x2 x3 x4 x5 x6 x7 x8)
.

Definition cupaco9 r := cpaco9 r r.

Lemma cpaco9_def_mon : monotone9 (compose gf (rclo9 clo)).
Proof.
  eapply monotone9_compose. apply gf_mon. apply rclo9_mon.
Qed.

Hint Resolve cpaco9_def_mon : paco.

Lemma cpaco9_mon r r' rg rg' x0 x1 x2 x3 x4 x5 x6 x7 x8
      (IN: @cpaco9 r rg x0 x1 x2 x3 x4 x5 x6 x7 x8)
      (LEr: r <9= r')
      (LErg: rg <9= rg'):
  @cpaco9 r' rg' x0 x1 x2 x3 x4 x5 x6 x7 x8.
Proof.
  destruct IN. econstructor.
  eapply rclo9_mon. apply IN.
  intros. destruct PR. left. apply LEr, H.
  right. eapply paco9_mon. apply H. apply LErg.
Qed.

Lemma cpaco9_base r rg: r <9= cpaco9 r rg.
Proof.
  econstructor. apply rclo9_base. left. apply PR.
Qed.

Lemma cpaco9_rclo r rg:
  rclo9 clo (cpaco9 r rg) <9= cpaco9 r rg.
Proof.
  intros. econstructor. apply rclo9_rclo.
  eapply rclo9_mon. apply PR.
  intros. apply PR0.
Qed.

Lemma cpaco9_clo r rg:
  clo (cpaco9 r rg) <9= cpaco9 r rg.
Proof.
  intros. apply cpaco9_rclo. apply rclo9_clo.
  eapply clo_compat. apply PR.
  intros. apply rclo9_base. apply PR0.
Qed.

Lemma cpaco9_step r rg:
  gf (cpaco9 rg rg) <9= cpaco9 r rg.
Proof.
  intros. econstructor. apply rclo9_base. right.
  pstep. eapply gf_mon. apply PR.
  intros. destruct PR0.
  eapply rclo9_mon. apply IN.
  intros. destruct PR0; [right|left]; apply H.
Qed.

Lemma cpaco9_init:
  cpaco9 bot9 bot9 <9= paco9 gf bot9.
Proof.
  intros. destruct PR. revert x0 x1 x2 x3 x4 x5 x6 x7 x8 IN.
  pcofix CIH. intros.
  pstep. eapply gf_mon; [| right; apply CIH, rclo9_rclo, PR]. 
  apply compat9_compat with (gf:=gf). apply rclo9_compat. apply gf_mon. apply clo_compat.
  eapply rclo9_mon. apply IN.
  intros. destruct PR. contradiction.
  _punfold H; [..|apply cpaco9_def_mon]. eapply cpaco9_def_mon. apply H.
  intros. pclearbot. right. apply PR.
Qed.

Lemma cpaco9_final:
  paco9 gf bot9 <9= cpaco9 bot9 bot9.
Proof.
  intros. econstructor. apply rclo9_base.
  right. eapply paco9_mon_bot. apply PR.
  intros. eapply gf_mon. apply PR0.
  intros. apply rclo9_base. apply PR1.
Qed.

Lemma cpaco9_unfold:
  cpaco9 bot9 bot9 <9= gf (cpaco9 bot9 bot9).
Proof.
  intros. apply cpaco9_init in PR. _punfold PR; [..|apply gf_mon].
  eapply gf_mon. apply PR.
  intros. pclearbot. apply cpaco9_final, PR0.
Qed.

Lemma cpaco9_cofix
      r rg (LE: r <9= rg)
      l (OBG: forall rr (INC: rg <9= rr) (CIH: l <9= rr), l <9= cpaco9 r rr):
  l <9= cpaco9 r rg.
Proof.
  assert (IN: l <9= cpaco9 r (rg \9/ l)).
  { intros. apply OBG; [left; apply PR0 | right; apply PR0 | apply PR]. }
  clear OBG. intros. apply IN in PR.
  destruct PR. econstructor.
  eapply rclo9_mon. apply IN0.
  clear x0 x1 x2 x3 x4 x5 x6 x7 x8 IN0.
  intros. destruct PR. left. apply H.
  right. revert x0 x1 x2 x3 x4 x5 x6 x7 x8 H.
  pcofix CIH. intros.
  _punfold H0; [..|apply cpaco9_def_mon]. pstep.
  eapply gf_mon. apply H0. intros.
  apply rclo9_rclo. eapply rclo9_mon. apply PR.
  intros. destruct PR0.
  - apply rclo9_base. right. apply CIH. apply H.
  - destruct H.
    + apply rclo9_base. right. apply CIH0, H.
    + apply IN in H. destruct H.
      eapply rclo9_mon. apply IN0.
      intros. destruct PR0.
      * right. apply CIH0. apply LE, H.
      * right. apply CIH. apply H.
Qed.

Lemma cpaco9_cupaco
      r rg (LEr: r <9= rg):
  cupaco9 (cpaco9 r rg) <9= cpaco9 r rg.
Proof.
  eapply cpaco9_cofix. apply LEr.
  intros. destruct PR. econstructor.
  apply rclo9_rclo. eapply rclo9_mon. apply IN.
  intros. destruct PR.
  - destruct H.  eapply rclo9_mon. apply IN0.
    intros. destruct PR. left. apply H.
    right. eapply paco9_mon. apply H. apply INC.
  - apply rclo9_base. right.
    eapply paco9_mon. apply H.
    intros. apply CIH.
    econstructor. apply rclo9_base. left. apply PR.
Qed.

Lemma cpaco9_uclo (uclo: rel -> rel)
      r rg (LEr: r <9= rg)
      (LEclo: uclo <10= cupaco9) :
  uclo (cpaco9 r rg) <9= cpaco9 r rg.
Proof.
  intros. apply cpaco9_cupaco. apply LEr. apply LEclo, PR.
Qed.

End CompatiblePaco9_main.

Lemma cpaco9_mon_gen (gf gf' clo clo': rel -> rel) x0 x1 x2 x3 x4 x5 x6 x7 x8 r r' rg rg'
      (IN: @cpaco9 gf clo r rg x0 x1 x2 x3 x4 x5 x6 x7 x8)
      (MON: monotone9 gf)
      (LEgf: gf <10= gf')
      (LEclo: clo <10= clo')
      (LEr: r <9= r')
      (LErg: rg <9= rg') :
  @cpaco9 gf' clo' r' rg' x0 x1 x2 x3 x4 x5 x6 x7 x8.
Proof.
  eapply cpaco9_mon; [|apply LEr|apply LErg].
  destruct IN. econstructor.
  eapply rclo9_mon_gen. apply IN. apply LEclo.
  intros. destruct PR. left; apply H.
  right. eapply paco9_mon_gen. apply H.
  - intros. eapply LEgf.
    eapply MON. apply PR.
    intros. eapply rclo9_mon_gen. apply PR0. apply LEclo. intros; apply PR1.
  - intros. apply PR.
Qed.

End CompatiblePaco9.

Hint Resolve cpaco9_base : paco.
Hint Resolve cpaco9_step : paco.
Hint Resolve rclo9_base : paco.
Hint Resolve rclo9_clo : paco.
