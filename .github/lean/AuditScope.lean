import DedekindZetaZeroFree.Main
import Lean.Util.CollectAxioms

-- The continuation agrees with Mathlib's Dedekind zeta function to the
-- right of 1 and has no zeros to the right of 31/32, away from the pole.
example (K : Type) [Field K] [NumberField K] :
    ∃ f : ℂ → ℂ, DifferentiableOn ℂ f ({1}ᶜ : Set ℂ) ∧
      (∀ s : ℂ, 1 < s.re → f s = NumberField.dedekindZeta K s) ∧
      ∀ s : ℂ, 31 / 32 < s.re → s ≠ 1 → f s ≠ 0 :=
  DedekindZetaZeroFree.dedekindZeta_ne_zero K

open Lean in
run_cmd do
  let axioms ← collectAxioms `DedekindZetaZeroFree.dedekindZeta_ne_zero
  for ax in axioms.toList do
    unless ax == `propext || ax == `Classical.choice || ax == `Quot.sound do
      throwError "Unexpected axiom in Dedekind theorem: {ax}"
  IO.println s!"AUDIT_AXIOMS={String.intercalate "," (axioms.toList.map toString)}"
  IO.println "AUDIT_SCOPE=passed"
