/*
  Contract templates for NGI / Summer of Nix

  Example:

  Run `nix-build contract.nix -A 2024-01 -o 2024-01.pdf` on the following file.

  ```nix
  # contract.nix
  let
    contract = import ./ngi.nix;
    foundation = {
      representative = "Jan Jansen";
      address = ''
        Lorem 123
        45678 Ipsum
        Dolor Sit
      '';
    };
    toPDF = number: parameters:
    contract.pdf "${number}.pdf" (parameters { inherit number foundation; });
  in
  mapAttrs toPDF {
    "2023-01" = contract.participant {
      name = "John Default";
      address = ''
          Fakestreet 123
          Springfield
          USA
      '';
      amount = 3000;
    };
  }
  ```
*/
let
  contracts = import ./.;

  definitions = {
    ngi0 = ''
      **NGI0** is a consortium of not-for-profit organisations that has received funding through the Next Generation Internet initiative within the European Commission's Horizon Europe program coordinated by the DG CNECT.
      **NGI0** aims to contribute to an open internet that is resilient, trustworthy, and sustainable, by
      * Providing uniform, convenient access to innovative technologies produced in the research and development efforts it is funding.
      * Encouraging robust software engineering practices such as continuous integration, testing, and reproducible builds.
      The **NixOS Foundation** is part of the **NGI0** consortium, and responsible for supporting projects funded by **NGI0** with reproducible builds and packaging with Nix and related tooling.
    '';
    summer-of-nix = ''
      **Summer of Nix** is a program organised by the **NixOS Foundation** in collaboration with the **NLnet Foundation** to package applications relevant to **NGI0**, and train a new generation of software professionals.
    '';
    participant = ''
      A **Participant** takes part in the **Summer of Nix** program, and will perform software packaging and related activities for **NGI0** and the Next Generation Internet initiative.
    '';
    facilitator = ''
      A **Facilitator** assembles a team (a mob) and facilitates the mob programming format with **Participants** during **Summer of Nix**.
    '';
    developer = ''
      A **Developer** is an independent software expert and a respected member of the Nix community, who supports open source R&D efforts that are funded by **NGI0**.
    '';
  };

  terms = {
    purpose = { role }: ''
      The purpose of this engagement is to further the technical goals of the **NGI0** consortium according to the responsibilities of **NixOS Foundation**.
    '';
    time-frame = { role }: contracts.terms.time-frame {
      time-frame = "from 2023-10-14 to 2023-12-31";
      inherit role;
    };
    facilitator-duties = { role }: ''
      **${role}** will take applications and assemble a team (a mob) of four **Participants** and themselves.

      **${role}** will set up, schedule, and run 160 hours of mob programming sessions according to agreed-upon goals and priorities.

      **${role}** is responsible that their mob regularly provides brief written overviews of work done, for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
    '';
    participant-duties = { role }: ''
      **${role}** will participate in 160 hours of mob sessions led by a **Facilitator** according to an agreed-upon schedule, and work according to the mob's goals and priorities.

      **${role}** will collaborate on regularly providing brief written overviews of their mob's work results for the purpose of the **NixOS Foundation** reporting to financiers and the general public.
    '';
    technical-means = { role }: ''
      **${role}** is responsible to ensure that the technical means required for their effective participation in mob programming sessions are available and operational.
    '';
    developer-duties = { role }: ''
      **${role}** assumes the moral and operational responsibility for the software projects they engage with.
      For the duration of this engagement, **${role}** is said to be a maintainer for these projects.
      This encompasses making, documenting, and implementing technical decisions (collaboratively where appropriate), being available and responsive to other maintainers of the projects, and what is otherwise deemed customary in maintaining open source software.
    '';
    project-organiser-duties = { role }: ''
      **${role}** is responsible for executing the organisational aspects of the **Summer of Nix** 2024 program, including in particular:
      - Issue a public call for applications
      - Process applications and select **Facilitators**
      - Instruct **Facilitators** and **Participants** on mob pramming
      - Help connect corporate sponsors and program graduates
      - Assistist the **NGI project manager** with administrative tasks
    '';
    project-manager-duties = { role }: ''
      The mission for **${role}** is to help fulfil the **NixOS Foundation**’s **NGI0** program duties and furthering technical goals of the **NGI0** consortium, reducing administrative friction, and increasing visibility of work done.

      Tasks on behalf of NixOS Foundation include:
      - Gather requirements and priorities from stakeholders
      - Determine and communicate priorities, allocate budgets
      - Prepare contracts
      - Keep track of progress and spending
      - Compile and publish reports
      - Help connect corporate sponsors and program graduates
      - Organise a public outreach effort
      - Assist with various administrative tasks
    '';
    technical-means = { role }: ''
      **${role}** is responsible to ensure that the technical means required for their effective participation in mob programming sessions are available and operational.
    '';
    time-sheets = { role }: ''
      **${role}** will submit monthly time sheets to the **NixOS Foundation**, detailing the effort by the hour.
    '';
    invoicing = { role }: ''
      Compensation will be paid out in two parts, each after completing half of the agreed-upon work hours.
      Invoices shall be submitted to the **NixOS Foundation** within 30 calendar days of the billed work being done.

      Payment is conditional on satisfactory participation in the program, subject to assessment of the **Project Organiser**.
      In case of a dispute, parties may appeal to the **NixOS Foundation**.
    '';
    subcontracting = _: ''
      Subcontracting the agreed-upon work is explicitly prohibited.
    '';
    acknowledgement = { role }: ''
      **${role}** is encouraged to publicly acknowledge the **NixOS Foundation**'s and European Commission's support and contribution where possible.
      For example: on websites, in promotional materials or presentations, and in source code.
    '';
  };

  summer-of-nix-definitions =
    with contracts.definitions;
    with definitions;
    [
      nix
      nixos-foundation
      ngi0
      definitions.summer-of-nix
      participant
      facilitator
      project-organiser
    ];
in
{
  # pass through the underlying rendering mechanism
  inherit (contracts) pdf;

  participant = { name, address, amount }:
    let
      role = "Participant";
      compensation =
        let
          total-amount = contracts.terms.total-amount { inherit role amount; };
          time-frame = terms.time-frame { inherit role; };
        in
        [
          total-amount
          time-frame
        ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        purpose
        participant-duties
        technical-means
        priorities
        time-sheets
        terms.invoicing
        invoiced-amount
        payment-duties
        availability
        subcontracting
        no-claims
        taxes
        license
        code-of-conduct
        public-statements
        acknowledgement
      ];
    in
    contracts.contract {
      contractor = { inherit name address role; };
      definitions = summer-of-nix-definitions;
      terms = role-terms;
      inherit compensation;
    };

  facilitator = { name, address, amount }:
    let
      role = "Facilitator";
      compensation =
        let
          total-amount = contracts.terms.total-amount { inherit role amount; };
          time-frame = terms.time-frame { inherit role; };
        in
        [
          total-amount
          time-frame
        ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        purpose
        facilitator-duties
        technical-means
        subcontracting
        priorities
        progress-reviews
        written-summaries
        time-sheets
        terms.invoicing
        invoiced-amount
        payment-duties
        availability
        no-claims
        taxes
        license
        code-of-conduct
        public-statements
        acknowledgement
      ];
    in
    contracts.contract {
      contractor = { inherit name address role; };
      definitions = summer-of-nix-definitions;
      terms = role-terms;
      inherit compensation;
    };

  developer = { name, address, hours, rate }:
    let
      role = "Developer";
      compensation =
        let
          hours-and-rate = contracts.terms.hours-and-rate { inherit role hours rate; };
          time-frame = terms.time-frame { inherit role; };
        in
        [
          hours-and-rate
          time-frame
        ];
      ngi-definitions = with contracts.definitions; with definitions; [
        nix
        nixos-foundation
        ngi0
        developer
        project-organiser
      ];
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        purpose
        priorities
        progress-reviews
        written-summaries
        developer-duties
        technical-means
        contracts.terms.invoicing
        invoiced-amount
        payment-duties
        availability
        subcontracting
        no-claims
        taxes
        license
        code-of-conduct
        public-statements
        acknowledgement
      ];
    in
    contracts.contract {
      contractor = { inherit name address role; };
      definitions = ngi-definitions;
      terms = role-terms;
      inherit compensation;
    };

  organiser = { name, address, hours, rate }:
    let
      role = "Project Organiser";
      compensation =
        let
          hours-and-rate = contracts.terms.hours-and-rate { inherit role hours rate; };
          time-frame = terms.time-frame { inherit role; };
        in
        [
          hours-and-rate
          time-frame
        ];
      public-statements = { role }: contracts.terms.public-statements { inherit role; optional = false; };
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        project-organiser-duties
        contracts.terms.invoicing
        invoiced-amount
        payment-duties
        availability
        no-claims
        taxes
        license
        code-of-conduct
        public-statements
        acknowledgement
      ];
    in
    contracts.contract {
      contractor = { inherit name address role; };
      definitions = summer-of-nix-definitions;
      terms = role-terms;
      inherit compensation;
    };
  project-manager = { name, address, hours, rate }:
    let
      role = "NGI Project Manager";
      compensation =
        let
          hours-and-rate = contracts.terms.hours-and-rate { inherit role hours rate; };
          time-frame = terms.time-frame { inherit role; };
        in
        [
          hours-and-rate
          time-frame
        ];
      public-statements = { role }: contracts.terms.public-statements { inherit role; optional = false; };
      role-terms = with contracts.terms; with terms; map (t: t { inherit role; }) [
        project-manager-duties
        contracts.terms.invoicing
        invoiced-amount
        payment-duties
        availability
        no-claims
        taxes
        license
        code-of-conduct
        public-statements
        acknowledgement
      ];
    in
    contracts.contract {
      contractor = { inherit name address role; };
      definitions = summer-of-nix-definitions;
      terms = role-terms;
      inherit compensation;
    };
}