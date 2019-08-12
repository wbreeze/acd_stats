# acd_stats
Aerobatic contest data statistical analyses and reports

The `aerobatDB` directory contains code for an R package that queries
International Aerobatic Club (IAC)
aerobatic contest data published electronically as
[IACCDB](https://iaccdb.iac.org/)
and produces R data frames for analysis.

The `aerobatStats` directory contains code for an R package that
uses the `aerobatDB` package to retrieve data and make statistical
explorations of aerobatic contest data.

## Aerobatic Competition

Aerobatics, as practiced by CIVA and the IAC, is a judged sport.
In aerobatics, pilots fly figures made up of a basic flight path
overlaid with rolls, in which the airplane moves about it's fuselage
while it's center continues on the flight path.

The basic flight paths of the figures are made up of straight lines and
loops. Straight lines may be horizontal, vertical, or along a forty-five
degree line. Loops are segments of a circle of constant radius. They occur
in transitions between lines. Their segments may form anything from
one-eighth of a circle to an entire circle in one-eighth increments.

Rolls superimposed on the flight paths are subdivided into those in which
the air maintains laminar flow over the surface of the airplane and those
in which the flow is turbulent over part of the wing. The former are
generally referred to as "aileron-rolls" or simply "rolls." 
The latter are referred to as "snap-rolls" or "flick-rolls", and "spins".

Aileron rolls and snap rolls may occur on any line, and at the top of full
loops.  Spins are always performed on a vertical line moving down.  Rolls can
occur in one-eighth increments up to two full rolls, and may be broken-up with
pauses, called "points", in increments of one-eighth, one-quarter, and one-half
of a full roll.

The sport maintains a catalog of flight paths and rolls named
the ["Aresti catalog"](https://en.wikipedia.org/wiki/Aresti_Catalog)
after its developer, Spanish aviator Colonel José Luis Aresti Aguirre.  The
Aresti catalog systematically assigns difficulty, a "K-factor" to each figure.

A "flight program" consists of each of the competing pilots flying a sequence
of figures in front of the judges. The sequences of figures are predetermined
for the flight program by any one of several methods.
Judges receive the sequences that each pilot will fly in order to evaluate
the sequence actually flown against the sequence commited to fly by the pilot.

### Grading

The judges give each figure a grade from zero to ten in half point increments.
They start from a perfect score of ten, and systematically deduct for flaws in
the direction of the flight path, radius of loops, and degrees of roll.  Thus,
a flight program produces a three-dimensional matrix of grades consisting of
Pilot X Judge X Figure.  Each pilot receives one grade from each judge for each
figure.

[Aerobatic Competition Grades
(illustration)](file:./AerobaticCompetitionGrades.jpg)

To complicate the grading slightly, a zero grade can take multiple forms.
One form is that incremental flaws resulted in deductions that summed to
ten or more. This is known as a "soft zero". A second form is that the
figure flown did not match the figure that was supposed to be flown.
It might have been missing a roll element or not have been flown along
the prescribed flight path. This is known as a "hard zero". CIVA uses
a form known as a "presentation zero" that a judge may use to indicate
suspicion of a hard zero. A "conference zero" indicates that the judge
changed their grade to a hard zero in review following the performance
of the pilot.

A judge may also give a grade of "average". A grade of average indicates
that the judge was either distracted or unsure of the figure that was
prescribed to be flown and therefore unable to evaluate the figure performed
against the figure prescribed. It is preferred that the judge give an
average under these conditions, rather than make-up a grade.
The effect of averages is a reduction in the number of judges evaluating
the figure.
