let
  ngi = import ./.;
  inherit (ngi) contracts;
in

{ name, address, amount, hours ? 160, time-frame ? "from 2025-06-09 to 2025-09-05" }:
let
  role = "Participant";
  duties = { role }: ''
    **${role}** will contribute ${toString hours} hours to the Summer of Nix program, coordinate their activities with their **Mentor** according to an agreed-upon schedule, and work on improving the deployment story of select software projects by writing Nix derivations, NixOS modules, integration tests, and documentation, in line with the program's goals and priorities.

    **${role}** will collaborate on regularly providing brief written overviews of their work results for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
  '';
  priorities = { role }: contracts.terms.priorities { inherit role; supervisor = "NGI Project Manager"; };
  availability = { role }: contracts.terms.availability {
    inherit role;
    supervisor = "NGI Project Manager";
  };
  compensation =
    let
      money = contracts.terms.compensation { inherit role amount; };
      time = contracts.terms.time-frame { inherit role time-frame; };
    in
    [ money time ];
  terms =
    let
      generic = contracts.terms;
    in
    map (t: t { inherit role; }) [
      ngi.terms.purpose
      duties
      ngi.terms.technical-means
      priorities
      ngi.terms.time-sheets
      ngi.terms.invoicing
      generic.invoiced-amount
      generic.payment-duties
      availability
      generic.no-subcontracting
      generic.no-claims
      generic.taxes
      generic.license
      generic.privacy
      generic.code-of-conduct
      generic.public-statements
      ngi.terms.acknowledgement
    ];
in
contracts.contract {
  contractor = { inherit name address role; };
  inherit compensation terms;
  definitions = ngi.summer-of-nix-definitions;
}
