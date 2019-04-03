from __future__ import print_function
import sys
from pacolib import *

if len(sys.argv) < 2:
    sys.stderr.write("\nUsage: "+sys.argv[0]+" relsize\n\n")
    sys.exit(1)

relsize = int(sys.argv[1])
n = relsize

print ("Require Import paco"+str(n)+" cpn"+str(n)+" cpntac.")
print ("Set Implicit Arguments.")
print ("")

print ("Section WCompanion"+str(n)+".")
print ("")

for i in range(n):
    print ("Variable T"+str(i)+" : "+ifpstr(i,"forall"),end="")
    for j in range(i):
        print (" (x"+str(j)+": @T"+str(j)+itrstr(" x",j)+")",end="")
    print (ifpstr(i,", ")+"Type.")
print ("")

print ("Local Notation rel := (rel"+str(n)+itrstr(" T", n)+").")
print ("")

print ("Section WCompanion"+str(n)+"_main.")
print ("")

print ("Variable gf: rel -> rel.")
print ("Hypothesis gf_mon: monotone"+str(n)+" gf.")
print ("")

print ("Variable bnd: rel -> rel.")
print ("Hypothesis bnd_compat : compatible_bound"+str(n)+" gf bnd.")
print ("")

print ("Inductive gcpn"+str(n)+" (r rg : rel)"+itrstr(" e", n)+" : Prop :=")
print ("| gcpn"+str(n)+"_intro (IN: cpn"+str(n)+" gf bnd (r \\"+str(n)+"/ fcpn"+str(n)+" gf bnd rg)"+itrstr(" e", n)+")")
print (".              ")
print ("")
print ("Lemma gcpn"+str(n)+"_mon r r' rg rg'"+itrstr(" e", n)+"")
print ("      (IN: @gcpn"+str(n)+" r rg"+itrstr(" e", n)+")")
print ("      (LEr: r <"+str(n)+"= r')")
print ("      (LErg: rg <"+str(n)+"= rg'):")
print ("  @gcpn"+str(n)+" r' rg'"+itrstr(" e", n)+".")
print ("Proof.")
print ("  destruct IN. constructor.")
print ("  eapply cpn"+str(n)+"_mon. apply IN. intros.")
print ("  destruct PR. left. apply LEr, H. right.")
print ("  eapply fcpn"+str(n)+"_mon. apply gf_mon. apply H. apply LErg.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_init r: gcpn"+str(n)+" r r <"+str(n)+"= cpn"+str(n)+" gf bnd r.")
print ("Proof.")
print ("  intros. destruct PR.")
print ("  ucpn.")
print ("  eapply cpn"+str(n)+"_mon; [apply IN|].")
print ("  intros. destruct PR.")
print ("  - ubase. apply H.")
print ("  - ustep. apply H.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_final r rg: cpn"+str(n)+" gf bnd r <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  constructor. eapply cpn"+str(n)+"_mon. apply PR.")
print ("  intros. left. apply PR0.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_unfold:")
print ("  gcpn"+str(n)+" bot"+str(n)+" bot"+str(n)+" <"+str(n)+"= gf (gcpn"+str(n)+" bot"+str(n)+" bot"+str(n)+").")
print ("Proof.")
print ("  intros. apply gcpn"+str(n)+"_init in PR. uunfold PR.")
print ("  eapply gf_mon; [apply PR|].")
print ("  intros. apply gcpn"+str(n)+"_final. apply PR0.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_base r rg:")
print ("  r <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  intros. constructor. ubase. left. apply PR.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_bound r rg:")
print ("  bnd r <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  intros. econstructor. apply cpn"+str(n)+"_bound. apply bnd_compat.")
print ("  eapply cbound"+str(n)+"_mon.")
print ("  - apply bnd_compat.")
print ("  - apply PR.")
print ("  - intros. left. apply PR0.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_step r rg:")
print ("  gf (gcpn"+str(n)+" rg rg) <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  intros. constructor. ubase. right.")
print ("  eapply gf_mon. apply PR.")
print ("  intros. apply gcpn"+str(n)+"_init. apply PR0.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_cpn r rg:")
print ("  cpn"+str(n)+" gf bnd (gcpn"+str(n)+" r rg) <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  intros. constructor. ucpn.")
print ("  eapply cpn"+str(n)+"_mon. apply PR.")
print ("  intros. destruct PR0. apply IN.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_clo r rg")
print ("      clo (LE: clo <"+str(n+1)+"= cpn"+str(n)+" gf bnd):")
print ("  clo (gcpn"+str(n)+" r rg) <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  intros. apply gcpn"+str(n)+"_cpn, LE, PR.")
print ("Qed.")
print ("")
print ("(*")
print ("  Fixpoint theorem of gcpn"+str(n)+"")
print (" *)")
print ("")
print ("Definition gcut"+str(n)+" (x y z: rel) : rel :="+ifpstr(n," fun"+itrstr(" e", n)+" =>")+" y <"+str(n)+"= z /\ x"+itrstr(" e", n)+".")
print ("")
print ("Definition gfixF"+str(n)+" (r rg z: rel) : rel := gcpn"+str(n)+" r (rg \\"+str(n)+"/ z).")
print ("")
print ("Definition gfix"+str(n)+" (r rg: rel) : rel := cpn"+str(n)+" (gfixF"+str(n)+" r rg) bot"+str(n+1)+" bot"+str(n)+".")
print ("")
print ("Lemma gfixF"+str(n)+"_mon r rg:")
print ("  monotone"+str(n)+" (gfixF"+str(n)+" r rg).")
print ("Proof.")
print ("  red; intros.")
print ("  eapply gcpn"+str(n)+"_mon. apply IN. intros. apply PR.")
print ("  intros. destruct PR. left. apply H. right. apply LE, H.")
print ("Qed.")
print ("")
print ("Local Hint Resolve gfixF"+str(n)+"_mon.")
print ("")
print ("Lemma gcut"+str(n)+"_mon x y : monotone"+str(n)+" (gcut"+str(n)+" x y).")
print ("Proof.")
print ("  repeat red. intros. destruct IN. split.")
print ("  - intros. apply LE, H, PR.")
print ("  - apply H0.")
print ("Qed.")
print ("")
print ("Lemma gcut"+str(n)+"_wcomp r rg (LE: r <"+str(n)+"= rg) :")
print ("  wcompatible"+str(n)+" gf bnd (gcut"+str(n)+" (gfix"+str(n)+" r rg) rg).")
print ("Proof.")
print ("  econstructor; [apply gcut"+str(n)+"_mon| |].")
print ("  { intros.")
print ("    destruct PR as [LEz FIX].")
print ("    uunfold FIX.")
print ("    eapply gf_mon, rclo"+str(n)+"_cpn.")
print ("    apply cpn"+str(n)+"_compat; [apply gf_mon|apply bnd_compat|].")
print ("    eapply cpn"+str(n)+"_mon; [apply FIX|]. clear"+itrstr(" x", n)+" FIX; intros.")
print ("")
print ("    destruct PR as [PR | PR].")
print ("    - apply LE in PR. apply LEz in PR.")
print ("      eapply gf_mon. apply PR.")
print ("      intros. apply rclo"+str(n)+"_base. apply PR0.")
print ("    - eapply gf_mon; [apply PR|]. clear"+itrstr(" x", n)+" PR; intros.")
print ("      eapply rclo"+str(n)+"_cpn.")
print ("      eapply cpn"+str(n)+"_mon. apply PR. clear"+itrstr(" x", n)+" PR; intros.")
print ("      destruct PR as [PR | PR].")
print ("      + apply rclo"+str(n)+"_step. eapply gf_mon. apply LEz, PR.")
print ("        intros. apply rclo"+str(n)+"_base, PR0.")
print ("      + apply rclo"+str(n)+"_clo. split.")
print ("        * intros. apply rclo"+str(n)+"_step.")
print ("          eapply gf_mon. apply LEz. apply PR0.")
print ("          intros. apply rclo"+str(n)+"_base. apply PR1.")
print ("        * apply PR.")
print ("  }")
print ("  { intros. apply (cbound"+str(n)+"_distr bnd_compat) in PR.")
print ("    destruct PR, IN.")
print ("    uunfold H0. destruct H0. specialize (PTW _ IN).")
print ("    eapply (compat"+str(n)+"_bound (cpn"+str(n)+"_compat gf_mon bnd_compat)) in PTW.")
print ("    destruct PTW as [BND|BND].")
print ("    - apply (cbound"+str(n)+"_distr bnd_compat) in BND. destruct BND.")
print ("      destruct IN0.")
print ("      + left. apply PTW, H, LE, H0.")
print ("      + specialize (PTW _ H0).")
print ("        apply (cbound"+str(n)+"_compat bnd_compat) in PTW.")
print ("        right. eapply gf_mon. apply PTW.")
print ("        intros. apply rclo"+str(n)+"_cpn, cpn"+str(n)+"_bound; [apply bnd_compat|].")
print ("        eapply cbound"+str(n)+"_mon. apply bnd_compat. apply PR.")
print ("        intros. apply rclo"+str(n)+"_cpn.")
print ("        eapply cpn"+str(n)+"_mon. apply PR0.")
print ("        intros. destruct PR1.")
print ("        * apply rclo"+str(n)+"_base. apply H, H1.")
print ("        * apply rclo"+str(n)+"_clo. econstructor; [|apply H1].")
print ("          intros. apply rclo"+str(n)+"_base. apply H, PR1.")
print ("    - right. eapply gf_mon. apply BND.")
print ("      intros. apply rclo"+str(n)+"_cpn.")
print ("      eapply cpn"+str(n)+"_mon. apply PR.")
print ("      intros. destruct PR0.")
print ("      + apply rclo"+str(n)+"_base. apply H, LE, H0.")
print ("      + apply rclo"+str(n)+"_step.")
print ("        eapply gf_mon. apply H0.")
print ("        intros. apply rclo"+str(n)+"_cpn.")
print ("        eapply cpn"+str(n)+"_mon. apply PR0.")
print ("        intros. destruct PR1.")
print ("        * apply rclo"+str(n)+"_base. apply H, H1.")
print ("        * apply rclo"+str(n)+"_clo. econstructor; [|apply H1].")
print ("          intros. apply rclo"+str(n)+"_base. apply H, PR1.")
print ("  }")
print ("Qed.")
print ("")
print ("Lemma gfix"+str(n)+"_le_cpn r rg (LE: r <"+str(n)+"= rg) :")
print ("  gfix"+str(n)+" r rg <"+str(n)+"= cpn"+str(n)+" gf bnd rg.")
print ("Proof.")
print ("  intros. eexists.")
print ("  - apply wcompat"+str(n)+"_compat, gcut"+str(n)+"_wcomp. apply gf_mon. apply bnd_compat. apply LE.")
print ("  - apply rclo"+str(n)+"_clo. split.")
print ("    + intros. apply rclo"+str(n)+"_base. apply PR0.")
print ("    + apply PR.")
print ("Qed.")
print ("")
print ("Lemma gfix"+str(n)+"_le_gcpn r rg (LE: r <"+str(n)+"= rg):")
print ("  gfix"+str(n)+" r rg <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  (*")
print ("    fix")
print ("    =")
print ("    c(r + gc(rg + fix))")
print ("    <=")
print ("    c(r + gc(rg + c(rg)))  (by Lemma fix"+str(n)+"_le_cpn)")
print ("    <=")
print ("    c(r + gc(rg))")
print ("   *)")
print ("  ")
print ("  intros. uunfold PR.")
print ("  destruct PR. constructor.")
print ("  eapply cpn"+str(n)+"_mon. apply IN. intros.")
print ("  destruct PR. left; apply H. right.")
print ("  eapply gf_mon.  apply H. intros.")
print ("  ucpn.")
print ("  eapply cpn"+str(n)+"_mon. apply PR. intros.")
print ("  destruct PR0.")
print ("  - ubase. apply H0.")
print ("  - eapply gfix"+str(n)+"_le_cpn. apply LE. apply H0.")
print ("Qed.")
print ("")
print ("Lemma gcpn"+str(n)+"_cofix: forall")
print ("    r rg (LE: r <"+str(n)+"= rg)")
print ("    l (OBG: forall rr (INC: rg <"+str(n)+"= rr) (CIH: l <"+str(n)+"= rr), l <"+str(n)+"= gcpn"+str(n)+" r rr),")
print ("  l <"+str(n)+"= gcpn"+str(n)+" r rg.")
print ("Proof.")
print ("  intros. apply gfix"+str(n)+"_le_gcpn. apply LE.")
print ("  eapply cpn"+str(n)+"_algebra, PR. apply gfixF"+str(n)+"_mon. apply cbound"+str(n)+"_bot.")
print ("  intros. eapply OBG; intros.")
print ("  - left. apply PR1.")
print ("  - right. apply PR1.")
print ("  - apply PR0.")
print ("Qed.")
print ("")
print ("End WCompanion"+str(n)+"_main.")
print ("")
print ("Lemma gcpn"+str(n)+"_mon_bot bnd bnd' (gf gf': rel -> rel)"+itrstr(" e", n)+" r rg")
print ("      (IN: @gcpn"+str(n)+" gf bnd bot"+str(n)+" bot"+str(n)+""+itrstr(" e", n)+")")
print ("      (MON: monotone"+str(n)+" gf)")
print ("      (MON': monotone"+str(n)+" gf')")
print ("      (BASE: compatible_bound"+str(n)+" gf bnd)")
print ("      (BASE': compatible_bound"+str(n)+" gf' bnd')")
print ("      (LE: gf <"+str(n+1)+"= gf'):")
print ("  @gcpn"+str(n)+" gf' bnd' r rg"+itrstr(" e", n)+".")
print ("Proof.")
print ("  destruct IN. constructor.")
print ("  eapply cpn"+str(n)+"_mon; [| intros; right; eapply PR].")
print ("  ubase.")
print ("  eapply fcpn"+str(n)+"_mon_bot, LE; [|apply MON|apply MON'|apply BASE|apply BASE'].")
print ("  eapply MON, cpn"+str(n)+"_cpn; [|apply MON|apply BASE].")
print ("  eapply (compat"+str(n)+"_compat (cpn"+str(n)+"_compat MON BASE)).")
print ("  eapply cpn"+str(n)+"_mon. apply IN.")
print ("  intros. destruct PR. contradiction. apply H.")
print ("Qed.")
print ("")
print ("End WCompanion"+str(n)+".")
print ("")
print ("Hint Resolve gcpn"+str(n)+"_base : paco.")
print ("Hint Resolve gcpn"+str(n)+"_step : paco.")
print ("")
