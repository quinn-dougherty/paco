Require Import paco12 pcpn12 pcpntac.
Set Implicit Arguments.

Section GeneralizedCompanion12.

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
Variable T10 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5) (x7: @T7 x0 x1 x2 x3 x4 x5 x6) (x8: @T8 x0 x1 x2 x3 x4 x5 x6 x7) (x9: @T9 x0 x1 x2 x3 x4 x5 x6 x7 x8), Type.
Variable T11 : forall (x0: @T0) (x1: @T1 x0) (x2: @T2 x0 x1) (x3: @T3 x0 x1 x2) (x4: @T4 x0 x1 x2 x3) (x5: @T5 x0 x1 x2 x3 x4) (x6: @T6 x0 x1 x2 x3 x4 x5) (x7: @T7 x0 x1 x2 x3 x4 x5 x6) (x8: @T8 x0 x1 x2 x3 x4 x5 x6 x7) (x9: @T9 x0 x1 x2 x3 x4 x5 x6 x7 x8) (x10: @T10 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9), Type.

Local Notation rel := (rel12 T0 T1 T2 T3 T4 T5 T6 T7 T8 T9 T10 T11).

Section GeneralizedCompanion12_main.

Variable gf: rel -> rel.
Hypothesis gf_mon: monotone12 gf.

Inductive gcpn12 (r rg : rel) x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 : Prop :=
| gcpn12_intro (IN: ucpn12 gf (r \12/ pcpn12 gf rg) x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)
.

Lemma gcpn12_mon r r' rg rg' x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11
      (IN: @gcpn12 r rg x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)
      (LEr: r <12= r')
      (LErg: rg <12= rg'):
  @gcpn12 r' rg' x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11.
Proof.
  destruct IN. constructor.
  eapply ucpn12_mon. apply IN. intros.
  destruct PR. left. apply LEr, H. right.
  eapply pcpn12_mon. apply H. apply LErg.
Qed.

Lemma gcpn12_init r: gcpn12 r r <12= ucpn12 gf r.
Proof.
  intros. ucpn. destruct PR.
  eapply ucpn12_mon; [apply IN|].
  intros. destruct PR.
  - ubase. apply H.
  - uunfold H. ustep. apply H.
Qed.

Lemma gcpn12_final r rg: ucpn12 gf r <12= gcpn12 r rg.
Proof.
  constructor. eapply ucpn12_mon. apply PR.
  intros. left. apply PR0.
Qed.

Lemma gcpn12_unfold:
  gcpn12 bot12 bot12 <12= gf (gcpn12 bot12 bot12).
Proof.
  intros. destruct PR. destruct IN.
  - uunfold H. eapply gf_mon. apply H.
    intros. econstructor. apply PR.
  - eapply gf_mon; [| intros; econstructor; right; apply PR].
    eapply (dcompat12_compat (dcpn12_compat gf_mon)).
    eapply dcpn12_mon. apply H.
    intros. destruct PR; try contradiction.
    uunfold H0. eapply gf_mon. apply H0.
    intros. right.
    apply pcpn12_final, ucpn12_init. apply gf_mon. apply PR.
Qed.

Lemma gcpn12_base r rg:
  r <12= gcpn12 r rg.
Proof.
  intros. constructor. ubase. left. apply PR.
Qed.

Lemma gcpn12_step r rg:
  gf (gcpn12 rg rg) <12= gcpn12 r rg.
Proof.
  intros. constructor. ubase. right. ustep.
  eapply gf_mon. apply PR.
  intros. destruct PR0.
  apply ucpn12_ucpn. apply gf_mon.
  eapply ucpn12_mon. apply IN.
  intros. destruct PR0.
  - ubase. apply H.
  - left. apply H.
Qed.

Lemma gcpn12_ucpn r rg:
  ucpn12 gf (gcpn12 r rg) <12= gcpn12 r rg.
Proof.
  intros. constructor. ucpn.
  eapply ucpn12_mon. apply PR.
  intros. destruct PR0. apply IN.
Qed.

Lemma gcpn12_clo r rg
      clo (LE: clo <13= ucpn12 gf):
  clo (gcpn12 r rg) <12= gcpn12 r rg.
Proof.
  intros. apply gcpn12_ucpn, LE, PR.
Qed.

(*
  Fixpoint theorem of gcpn12
 *)

Lemma gcpn12_cofix: forall
    r rg (LE: r <12= rg)
    l (OBG: forall rr (INC: rg <12= rr) (CIH: l <12= rr), l <12= gcpn12 r rr),
  l <12= gcpn12 r rg.
Proof.
Admitted.

End GeneralizedCompanion12_main.

Lemma gcpn12_mon_bot (gf gf': rel -> rel) x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 r rg
      (IN: @gcpn12 gf bot12 bot12 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11)
      (MON: monotone12 gf)
      (MON': monotone12 gf')
      (LE: gf <13= gf'):
  @gcpn12 gf' r rg x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11.
Proof.
  destruct IN. constructor.
  eapply ucpn12_mon; [| intros; right; eapply PR].
  ubase.
  eapply pcpn12_mon_bot, LE; [|apply MON].
  ustep.
  eapply MON, ucpn12_ucpn, MON.
  eapply ucpn12_compat; [apply MON|].
  eapply ucpn12_mon. apply IN.
  intros. destruct PR. contradiction. uunfold H. apply H.
Qed.

End GeneralizedCompanion12.

Hint Resolve gcpn12_base : paco.
Hint Resolve gcpn12_step : paco.

