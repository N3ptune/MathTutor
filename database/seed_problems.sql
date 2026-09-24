-- Hand-written problems (not templated/randomized), replacing the previous generated set.
-- Adds a 'Parametric Equations and Polar Curves' section to Calculus 2 (was missing).
-- WARNING: destructive. DELETE FROM problem cascades to user_problem_attempt (ON DELETE
-- CASCADE), so any recorded attempt history tied to existing problems is removed too.
-- Run this in the Supabase SQL editor against your live project.

insert into public.section (name, "courseId")
select 'Parametric Equations and Polar Curves', c."courseId"
from public.course c
where c.name = 'Calculus 2'
and not exists (
  select 1 from public.section s
  where s."courseId" = c."courseId" and s.name = 'Parametric Equations and Polar Curves'
);

delete from public.problem;

-- ================= Algebra 1 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $3x^2 - 2xy + y$ when $x = -2$ and $y = 5$.'),
    ('Write an algebraic expression for "the sum of a number and 7, doubled."'),
    ('A rectangle has length $\ell$ and width $w$. Write an expression for its perimeter, then evaluate it when $\ell = 12$ and $w = 5$.'),
    ('Simplify $4(x - 3) + 2(x + 5)$ by combining like terms.'),
    ('Evaluate $\frac{2a + b}{a - b}$ when $a = 6$ and $b = 2$.'),
    ('A phone plan costs 20 dollars plus 5 cents per text message. Write an expression for the total cost of sending $t$ texts, then find the cost of sending 140 texts.'),
    ('Determine whether $3(x + 2)$ and $3x + 2$ are equivalent expressions. Explain why or why not.'),
    ('Evaluate $x^2 - y^2$ when $x = 4$ and $y = -3$, and compare it to $(x-y)(x+y)$ evaluated the same way.')
) as p(txt)
where s.name = 'Variables and Expressions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve for $x$: $3(2x - 1) + 4 = 2(x + 5)$.'),
    ('A number is doubled, then 7 is subtracted, giving 15. Find the number by setting up and solving an equation.'),
    ('Solve $\frac{2x+1}{3} = \frac{x-2}{2}$.'),
    ('Solve $5x - 2 = 5x + 7$. What does the result tell you about the solution set?'),
    ('The perimeter of a rectangle is 54 cm, and the length is 3 cm more than twice the width. Set up and solve an equation to find the width.'),
    ('Solve for $x$: $0.25x + 3 = 0.1x + 9$.'),
    ('Three consecutive even integers sum to 72. Set up and solve an equation to find them.')
) as p(txt)
where s.name = 'Solving Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $-3(x - 2) \ge 2x + 1$, and graph the solution on a number line.'),
    ('A parking garage charges 5 dollars plus 2 dollars per hour. If you have at most 17 dollars to spend, write and solve an inequality for the number of hours $h$ you can park.'),
    ('Solve $2 < 3x - 4 \le 11$.'),
    ('Solve $|x - 4| < 6$.'),
    ('Solve $|2x + 1| \ge 5$.'),
    ('A student needs an average of at least 85 across four tests to earn an A. Their first three scores are 80, 88, and 90. Write and solve an inequality for the score needed on the fourth test.')
) as p(txt)
where s.name = 'Solving Linear Inequalities' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Graph $y = -\tfrac{2}{3}x + 4$ by plotting the $y$-intercept and using the slope to find a second point.'),
    ('Without graphing, determine whether the lines $y = 3x - 1$ and $y = 3x + 5$ are parallel, perpendicular, or neither.'),
    ('Determine whether the lines $2x + 3y = 6$ and $3x - 2y = 4$ are parallel, perpendicular, or neither.'),
    ('Find the slope of the line $4x - 2y = 8$ without solving for $y$ first, then check your answer by rewriting the equation in slope-intercept form.'),
    ('A line passes through $(2, -1)$ and is horizontal. Write its equation and describe its graph.'),
    ('Graph the line $x = -3$ and the line $y = 4$ on the same coordinate plane, and find the point where they intersect.')
) as p(txt)
where s.name = 'Graphing Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Write the equation of the line through $(1, 4)$ that is perpendicular to $y = -\tfrac{1}{2}x + 3$.'),
    ('A line has $x$-intercept $4$ and $y$-intercept $-6$. Write its equation in slope-intercept form.'),
    ('A taxi charges a 3 dollar flat fee plus 2 dollars per mile. Write an equation for the total cost $C$ in terms of miles driven $m$, and identify what the slope and $y$-intercept represent in context.'),
    ('Write the equation of the line that passes through $(-2, 5)$ and is parallel to the line through $(0, 0)$ and $(4, 6)$.'),
    ('Two points on a line are $(1, k)$ and $(4, 10)$. If the slope of the line is $2$, find $k$.'),
    ('Write the equation of the line with $x$-intercept $-2$ and slope $3$.')
) as p(txt)
where s.name = 'Writing Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve the system $y = 2x - 1$ and $y = -x + 5$ by graphing, then verify your solution algebraically.'),
    ('A movie theater sells adult tickets for 12 dollars and child tickets for 8 dollars. If 150 tickets were sold for a total of 1,560 dollars, set up and solve a system to find how many of each type were sold.'),
    ('Solve the system $3x - 2y = 4$ and $6x - 4y = 8$. What does the result tell you about the two lines?'),
    ('Solve the system $x + y = 6$ and $x - y = 2$ using elimination.'),
    ('Two numbers have a sum of 20. Three times the smaller number equals the larger number minus 4. Set up and solve a system to find the numbers.'),
    ('A boat travels 60 miles downstream in 3 hours and returns upstream in 5 hours. Set up a system using the boat speed in still water and the current speed, then solve it.')
) as p(txt)
where s.name = 'Systems of Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\frac{x^3 y^{-2}}{x^{-1} y^4}$, writing your answer with only positive exponents.'),
    ('A car worth 24,000 dollars depreciates by 15% each year. Write an exponential function for its value after $t$ years, and find its value after 5 years.'),
    ('Simplify $(2x^2y^{-1})^3$.'),
    ('Determine whether $f(x) = 3(0.8)^x$ represents exponential growth or decay, and explain how you know.'),
    ('A bacteria culture doubles every 20 minutes, starting with 50 bacteria. Write a function for the population after $t$ hours, and find the population after 2 hours.'),
    ('Solve for $x$: $2^{3x-1} = 32$.'),
    ('Without a calculator, determine which is larger: $2^{10}$ or $10^2$. Show your reasoning.')
) as p(txt)
where s.name = 'Exponents and Exponential Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Factor completely: $3x^3 - 12x$.'),
    ('Factor by grouping: $x^3 + 2x^2 - 9x - 18$.'),
    ('Factor completely: $2x^2 + 7x + 3$.'),
    ('The area of a rectangle is $x^2 + 5x - 24$. Find expressions for the length and width.'),
    ('Multiply and simplify $(2x - 3)^2$.'),
    ('Determine whether $x^2 + 6x + 9$ is a perfect square trinomial. If so, factor it; if not, explain why not.'),
    ('Factor completely: $x^4 - 16$.'),
    ('Subtract $(3x^2 - 5x + 2)$ from $(7x^2 + x - 4)$, and simplify.')
) as p(txt)
where s.name = 'Polynomials and Factoring' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A ball is thrown upward with height $h(t) = -16t^2 + 48t + 5$ (in feet, $t$ in seconds). Find how long it takes the ball to hit the ground.'),
    ('Solve $x^2 - 4x - 5 = 0$ two different ways: by factoring and by the quadratic formula. Verify you get the same solutions.'),
    ('Without solving, use the discriminant of $2x^2 - 3x + 5 = 0$ to determine how many real solutions the equation has.'),
    ('Find two numbers whose product is $-36$ and whose sum is $5$, by setting up and solving a quadratic equation.'),
    ('A rectangular garden has an area of 96 square feet, and its length is 4 feet more than its width. Set up and solve a quadratic equation to find the dimensions.'),
    ('Solve $x^2 = 7x$ by factoring. Explain the mistake in dividing both sides by $x$ instead.'),
    ('Find the vertex, axis of symmetry, and $x$-intercepts (if real) of $y = x^2 - 2x - 8$.')
) as p(txt)
where s.name ilike '%quadratic%' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\sqrt{50} + \sqrt{18} - \sqrt{8}$.'),
    ('Solve $\sqrt{3x + 1} - 2 = x - 5$, and check for extraneous solutions.'),
    ('Simplify $\frac{6}{\sqrt{2} + 1}$ by rationalizing the denominator.'),
    ('The formula $t = \sqrt{\frac{2h}{g}}$ gives the time (in seconds) for an object to fall a height $h$ (in meters), where $g = 9.8$. Find how long it takes an object to fall 20 meters.'),
    ('Solve $\sqrt{x+7} = \sqrt{2x - 3}$.'),
    ('Multiply and simplify $(\sqrt{5} + 2)(\sqrt{5} - 3)$.'),
    ('Explain why $\sqrt{x^2}$ is not always equal to $x$, and state what it does equal in general.')
) as p(txt)
where s.name = 'Radical Expressions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

-- ================= Calculus 2 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int x^2 \cos(x)\,dx$ (requires integration by parts twice).'),
    ('Evaluate $\int e^x \sin(x)\,dx$ (requires integration by parts twice and solving for the integral algebraically).'),
    ('Set up, but do not evaluate, the integration by parts for $\int x^3 \ln(x)\,dx$: identify $u$, $dv$, $du$, and $v$.'),
    ('Evaluate $\int \arctan(x)\,dx$.'),
    ('Use integration by parts to derive a reduction formula for $\int x^n e^x\,dx$ in terms of $\int x^{n-1} e^x\,dx$.'),
    ('Evaluate $\int_0^{\pi/2} x \sin(x)\,dx$.'),
    ('Evaluate $\int \sec^3(x)\,dx$.')
) as p(txt)
where s.name = 'Integration by Parts' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int \sin^3(x)\cos^2(x)\,dx$.'),
    ('Evaluate $\int \sin^2(x)\cos^2(x)\,dx$ using power-reducing identities.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{x^2\sqrt{x^2 - 9}}$, and state which substitution you chose and why.'),
    ('Evaluate $\int \tan^4(x)\,dx$.'),
    ('Evaluate $\int_0^2 \sqrt{4 - x^2}\,dx$ using trigonometric substitution, and interpret the result geometrically.'),
    ('Set up, but do not evaluate, the trigonometric substitution for $\int \frac{x^2\,dx}{\sqrt{9 + x^2}}$: state the substitution and what $dx$ becomes.'),
    ('Evaluate $\int \sec^2(x)\tan^3(x)\,dx$.')
) as p(txt)
where s.name = 'Trigonometric Integrals and Substitution' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Decompose $\frac{3x+5}{x^2 - x - 2}$ into partial fractions.'),
    ('Decompose $\frac{2x^2 + 3x - 1}{(x-1)(x^2+1)}$ into partial fractions (includes an irreducible quadratic factor).'),
    ('Evaluate $\int \frac{5x - 4}{x^2 - 4}\,dx$ using partial fractions.'),
    ('Decompose $\frac{x+1}{x^3 - x^2}$ into partial fractions (includes a repeated linear factor).'),
    ('Explain why the numerator $2x^2 - 1$ over the denominator $x^2 + 1$ must first be divided before applying partial fractions, and carry out the division.'),
    ('Evaluate $\int_2^3 \frac{1}{x^2 - 1}\,dx$ using partial fractions.')
) as p(txt)
where s.name = 'Partial Fraction Decomposition' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int_1^\infty \frac{1}{x^2}\,dx$, and interpret the result as the area under a curve.'),
    ('Determine whether $\int_1^\infty \frac{1}{\sqrt{x}}\,dx$ converges or diverges.'),
    ('Evaluate $\int_0^1 \frac{1}{\sqrt{x}}\,dx$ (improper due to a discontinuity at the lower limit).'),
    ('Evaluate $\int_{-\infty}^0 e^{2x}\,dx$.'),
    ('Use the comparison test to determine whether $\int_1^\infty \frac{1}{x^3 + 1}\,dx$ converges, without evaluating it directly.'),
    ('Determine all values of $p$ for which $\int_1^\infty \frac{1}{x^p}\,dx$ converges.'),
    ('Evaluate $\int_2^\infty \frac{1}{x(\ln x)^2}\,dx$.')
) as p(txt)
where s.name = 'Improper Integrals' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Set up, but do not evaluate, the integral for the area between $y = x^2$ and $y = 2x + 3$.'),
    ('Find the area between $y = x^2$ and $y = 2x + 3$ by evaluating the integral you set up.'),
    ('Use the disk method to find the volume when the region under $y = \sqrt{x}$ from $x=0$ to $x=4$ is rotated about the $x$-axis.'),
    ('Use the shell method to find the volume when the region under $y = x^2$ from $x=0$ to $x=2$ is rotated about the $y$-axis.'),
    ('Find the volume of the solid whose cross-sections perpendicular to the $x$-axis are squares, where the base is the region bounded by $y = \sqrt{x}$ and the $x$-axis from $x=0$ to $x=4$.'),
    ('Explain when you should use the shell method instead of the disk/washer method, using the region bounded by $y=x^2$ and $y=4$ rotated about the $y$-axis as an example.'),
    ('Find the volume when the region between $y = x^2$ and $y = x$ is rotated about the line $y = -1$.')
) as p(txt)
where s.name = 'Applications of Integration: Area and Volume' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Set up the arc length integral for $y = x^{3/2}$ from $x = 0$ to $x = 4$, then evaluate it.'),
    ('Find the surface area generated when $y = \sqrt{x}$ from $x = 1$ to $x = 4$ is revolved about the $x$-axis.'),
    ('Find the arc length of $y = \ln(\cos x)$ from $x = 0$ to $x = \pi/4$.'),
    ('A cable hangs in the shape of $y = \cosh(x)$ between $x = -1$ and $x = 1$. Find its length.'),
    ('Explain why the arc length formula $\int \sqrt{1 + (y'')^2}\,dx$ requires the integrand to be at least 1, and verify this from the formula.'),
    ('Find the arc length of $y = \frac{1}{3}(x^2+2)^{3/2}$ from $x=0$ to $x=3$.')
) as p(txt)
where s.name = 'Arc Length and Surface Area' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether $a_n = (-1)^n \frac{n}{n+1}$ converges. If it diverges, explain why using the definition of limit.'),
    ('Use the Squeeze Theorem to show that $a_n = \frac{\cos(n)}{n^2}$ converges to 0.'),
    ('Determine whether the sequence defined recursively by $a_1 = 2$, $a_{n+1} = \frac{1}{2}(a_n + \frac{2}{a_n})$ appears to converge, by computing the first four terms.'),
    ('Determine whether $a_n = \left(1 + \frac{1}{n}\right)^n$ converges, and if so, to what value.'),
    ('Determine whether $a_n = \frac{\ln(n)}{n}$ converges, using L''Hopital''s Rule on the corresponding function limit.'),
    ('Show that a sequence can be bounded but not convergent by giving an example and explaining why it fails to converge.')
) as p(txt)
where s.name = 'Sequences and Their Limits' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Use the integral test to determine whether $\sum_{n=2}^\infty \frac{1}{n \ln n}$ converges.'),
    ('Use the comparison test to determine whether $\sum_{n=1}^\infty \frac{1}{n^2 + 1}$ converges.'),
    ('Use the limit comparison test to determine whether $\sum_{n=1}^\infty \frac{n+1}{n^3 - 2}$ converges.'),
    ('Determine whether $\sum_{n=1}^\infty \frac{(-1)^{n+1}}{n}$ converges absolutely, conditionally, or diverges.'),
    ('Find the sum of the telescoping series $\sum_{n=1}^\infty \left(\frac{1}{n} - \frac{1}{n+1}\right)$.'),
    ('Use the root test to determine whether $\sum_{n=1}^\infty \left(\frac{n}{2n+1}\right)^n$ converges.'),
    ('Explain why the harmonic series $\sum \frac{1}{n}$ diverges even though its terms approach 0, and contrast it with $\sum \frac{1}{n^2}$.')
) as p(txt)
where s.name = 'Infinite Series and Convergence Tests' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the interval of convergence of $\sum_{n=1}^\infty \frac{(x-2)^n}{n \cdot 3^n}$, checking the endpoints.'),
    ('Find the radius of convergence of $\sum_{n=0}^\infty \frac{n! \, x^n}{n^n}$.'),
    ('Given that $\sum_{n=0}^\infty x^n = \frac{1}{1-x}$ for $|x|<1$, find a power series representation for $\frac{1}{1+x^2}$.'),
    ('Differentiate the power series for $\frac{1}{1-x}$ term by term to find a series for $\frac{1}{(1-x)^2}$, and state its radius of convergence.'),
    ('Find the interval of convergence of $\sum_{n=1}^\infty \frac{(-1)^n (x+1)^n}{n^2}$.')
) as p(txt)
where s.name = 'Power Series and Radius of Convergence' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the Taylor series for $f(x) = \frac{1}{x}$ centered at $x = 1$ (not at $x=0$), and state its interval of convergence.'),
    ('Use the known Maclaurin series for $e^x$ to write the first four terms of the Maclaurin series for $e^{-x^2}$.'),
    ('Find the Taylor polynomial of degree 3 for $f(x) = \sqrt{x}$ centered at $x = 4$.'),
    ('Use the Lagrange error bound to estimate the maximum error when approximating $\sin(0.1)$ using the third-degree Maclaurin polynomial for $\sin(x)$.'),
    ('Use a known Maclaurin series to evaluate $\lim_{x \to 0} \frac{\sin(x) - x}{x^3}$.'),
    ('Find the Maclaurin series for $x\cos(x^2)$ using the known series for $\cos(x)$.')
) as p(txt)
where s.name ilike '%taylor%' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find $\frac{dy}{dx}$ for the parametric curve $x = t^2 - 1$, $y = t^3 - t$, and determine the points where the tangent line is horizontal.'),
    ('Find the area enclosed by the loop of the parametric curve $x = t^3 + 1$, $y = 2t - t^2$ for $0 \le t \le 2$ by setting up $A = \int_0^2 y\,x''\,dt$ and evaluating.'),
    ('Find the area enclosed by the ellipse $x = a\cos\theta$, $y = b\sin\theta$ using the formula $A = -\int y\,x''\,d\theta$ over a full period.'),
    ('Find the arc length of the curve $x = \frac{1}{3}t^3$, $y = t^2 - 2$ from $t = 0$ to $t = 3$.'),
    ('Find the arc length of the astroid $x = a\cos^3\theta$, $y = a\sin^3\theta$ over one full period, $0 \le \theta \le 2\pi$.'),
    ('Convert the polar equation $r = 4\cos\theta$ to rectangular form, and identify the curve it represents.'),
    ('Find the area enclosed by one petal of the polar curve $r = 3\sin(2\theta)$.'),
    ('Set up, but do not evaluate, the integral for the arc length of the polar curve $r = \theta$ for $0 \le \theta \le \pi$.'),
    ('Find the slope of the tangent line to the polar curve $r = 1 + \cos\theta$ at $\theta = \pi/2$.')
) as p(txt)
where s.name = 'Parametric Equations and Polar Curves' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

-- ================= Algebra 2 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $3(2x-1) - 4 = 2(x+3) + 1$.'),
    ('Solve the compound inequality $-4 \le 2x + 2 < 10$, and graph the solution.'),
    ('Solve $|3x - 2| = 7$.'),
    ('Solve $|2x + 1| > 5$, and write the solution in interval notation.'),
    ('Plan A costs 30 dollars per month plus 10 cents per text; plan B costs 45 dollars per month flat. Set up and solve an inequality to find how many texts make plan A cheaper.'),
    ('Solve $-2 < \frac{x-1}{3} \le 4$.'),
    ('Determine, without solving, whether $5(x-2) = 5x - 7$ has no solution, one solution, or infinitely many solutions, and explain your reasoning.')
) as p(txt)
where s.name = 'Linear Equations and Inequalities Review' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve the system $x + y + z = 6$, $2x - y + z = 3$, $x + 2y - z = 5$ using elimination.'),
    ('A theater sells three types of tickets: child tickets for 5 dollars, adult tickets for 10 dollars, and senior tickets for 7 dollars. On a night when 200 tickets were sold for 1,600 dollars total, and the number of adult tickets was twice the number of child tickets, set up and solve a system to find how many of each type were sold.'),
    ('Determine whether the system $x + y = 4$, $2x + 2y = 9$ has no solution, one solution, or infinitely many, without fully solving it.'),
    ('Solve the system $2x - y = 1$, $x + 3y = 4$ using matrices (Cramer''s Rule or row reduction).'),
    ('Solve the system $x - y + 2z = 3$, $2x + y - z = 1$, $3x - 2z = 4$.'),
    ('A chemist mixes a 10% acid solution with a 30% acid solution to make 20 liters of a 22% solution. Set up and solve a system to find how many liters of each are needed.')
) as p(txt)
where s.name = 'Systems of Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A ball''s height is modeled by $h(t) = -16t^2 + 64t$. Find the maximum height and when it occurs, without using calculus.'),
    ('Write a quadratic function in vertex form whose graph has vertex $(3, -2)$ and passes through $(5, 6)$.'),
    ('Solve $x^4 - 5x^2 + 4 = 0$ by treating it as quadratic in $x^2$.'),
    ('Given that $3$ and $-2$ are roots of a quadratic equation, write the equation in standard form.'),
    ('Solve $2x^2 - 4x + 5 = 0$, and express the solutions in $a+bi$ form.'),
    ('Two numbers differ by 5, and their product is 84. Set up and solve a quadratic equation to find the numbers.'),
    ('Determine the values of $k$ for which $x^2 + kx + 9 = 0$ has exactly one real solution.')
) as p(txt)
where s.name = 'Quadratic Functions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given $P(x) = x^4 - x^3 - 7x^2 + x + 6$ and that $x = 1$ is a root, use synthetic division to factor $P(x)$ completely.'),
    ('Write a polynomial of least degree with real coefficients that has roots $2$, $-1$, and $3i$.'),
    ('Determine the end behavior of $P(x) = -2x^5 + 3x^3 - x$ without graphing, and explain your reasoning using the leading term.'),
    ('Use Descartes'' Rule of Signs to determine the possible number of positive and negative real roots of $P(x) = x^3 - 4x^2 + x + 6$.'),
    ('Divide $P(x) = 2x^3 - 3x^2 + 4x - 1$ by $(x + 2)$ using long division, and state the quotient and remainder.'),
    ('Sketch the general shape of $P(x) = (x-1)^2(x+3)$ near each of its roots, describing whether the graph crosses or touches the $x$-axis at each.')
) as p(txt)
where s.name = 'Polynomial Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\frac{x^2 - 5x + 6}{x^2 - 4} \cdot \frac{x+2}{x-3}$.'),
    ('Add $\frac{2}{x-1} + \frac{3}{x+2}$, writing the result as a single fraction.'),
    ('Solve $\frac{1}{x} + \frac{1}{x+2} = \frac{5}{6}$, and check for extraneous solutions.'),
    ('Simplify the complex fraction $\dfrac{\frac{1}{x} + \frac{1}{y}}{\frac{1}{x} - \frac{1}{y}}$.'),
    ('Pipe A alone fills a tank in 4 hours, pipe B alone in 6 hours. Set up and solve a rational equation for how long it takes both pipes together.'),
    ('Find the vertical and horizontal asymptotes of $f(x) = \frac{2x^2 - 3}{x^2 - 4}$, explaining your method for each.')
) as p(txt)
where s.name = 'Rational Expressions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $\sqrt{x+4} + \sqrt{x-1} = 5$ (requires isolating and squaring twice).'),
    ('Simplify $\sqrt[3]{40x^4y^7}$.'),
    ('Rationalize the denominator of $\dfrac{3}{\sqrt{x} - 2}$.'),
    ('Solve $x^{2/3} = 9$.'),
    ('Simplify $\sqrt{18} - \sqrt{50} + 2\sqrt{8}$.'),
    ('Explain, using an example, why squaring both sides of an equation can introduce extraneous solutions.')
) as p(txt)
where s.name = 'Radical Expressions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $9^{x-1} = 27^{2x}$ by writing both sides with the same base.'),
    ('Money invested at 6% annual interest compounded quarterly grows according to $A = P(1 + 0.06/4)^{4t}$. Find how long it takes an investment to double.'),
    ('Determine whether $f(x) = 5 \cdot 2^x$ and $g(x) = 5 \cdot 2^{-x}$ are reflections of each other, and describe the reflection.'),
    ('A radioactive substance decays according to $A(t) = A_0 e^{-0.03t}$. Find its half-life.'),
    ('Solve $2^x = 3^{x-1}$ using logarithms.'),
    ('Compare the long-run growth of $f(x) = 100x^2$ and $g(x) = 2^x$ by evaluating both at $x=10, 20, 30$, and describe what you observe.')
) as p(txt)
where s.name = 'Exponential Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $\log_2(x+3) + \log_2(x-3) = 4$, and check for extraneous solutions.'),
    ('Use the change of base formula to evaluate $\log_5(40)$ to three decimal places.'),
    ('Solve $\ln(x) + \ln(x-2) = \ln(3)$.'),
    ('Graph $f(x) = \log_2(x)$ and describe its domain, range, and asymptote.'),
    ('Simplify $\log_3(9^x)$ without a calculator.'),
    ('The pH of a solution is given by $\text{pH} = -\log_{10}[\text{H}^+]$. Find the hydrogen ion concentration of a solution with pH 4.5.')
) as p(txt)
where s.name = 'Logarithmic Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the sum of the infinite geometric series $8 + 4 + 2 + 1 + \cdots$.'),
    ('Write the first five terms of the sequence defined recursively by $a_1 = 3$, $a_n = 2a_{n-1} - 1$.'),
    ('A sequence is arithmetic with $a_3 = 11$ and $a_7 = 27$. Find $a_1$ and $d$.'),
    ('Determine whether the geometric series $\sum_{n=1}^\infty 5(1.2)^n$ has a finite sum. If so, find it; if not, explain why.'),
    ('Use sigma notation to write the sum $3 + 6 + 9 + \cdots + 300$, then evaluate it.'),
    ('A ball dropped from 10 feet bounces back to 60% of its previous height each time. Find the total vertical distance it travels.')
) as p(txt)
where s.name = 'Sequences and Series' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Write the equation of the parabola with vertex $(2, -1)$ and focus $(2, 1)$.'),
    ('Convert $x^2 + 4y^2 - 6x + 16y + 21 = 0$ to standard form and identify the conic.'),
    ('Find the foci of the ellipse $\frac{(x-1)^2}{25} + \frac{(y+2)^2}{9} = 1$.'),
    ('Write the equation of a hyperbola centered at the origin with vertices at $(\pm 3, 0)$ and foci at $(\pm 5, 0)$.'),
    ('Determine, from the general equation $Ax^2 + Cy^2 + Dx + Ey + F = 0$, what conditions on $A$ and $C$ produce a circle, an ellipse, and a hyperbola.'),
    ('Find the asymptotes of the hyperbola $\frac{x^2}{9} - \frac{y^2}{16} = 1$.')
) as p(txt)
where s.name = 'Conic Sections' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

-- ================= Trigonometry =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A wheel of radius 14 inches rotates through an angle of $\frac{2\pi}{3}$ radians. Find the length of the arc traced and the area of the sector swept.'),
    ('Find two coterminal angles (one positive, one negative) for $\theta = 400^\circ$.'),
    ('A pendulum of length 2 meters swings through an angle of $15^\circ$. Find the arc length traveled by the pendulum''s tip.'),
    ('Convert $\theta = -\frac{7\pi}{4}$ to degrees, and find its reference angle.'),
    ('Find the angular speed (in radians per second) of a wheel making 300 revolutions per minute.'),
    ('Determine which quadrant $\theta = 5$ radians lies in.')
) as p(txt)
where s.name = 'Angles and Radian Measure' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A ladder leans against a wall, making a $65^\circ$ angle with the ground, reaching 12 feet up the wall. Find the length of the ladder.'),
    ('From a point 100 feet from the base of a building, the angle of elevation to the top is $38^\circ$. Find the height of the building.'),
    ('In right triangle $ABC$, $\sin(A) = \frac{5}{13}$. Find $\cos(A)$ and $\tan(A)$ without finding the angle itself.'),
    ('Two observers stand 500 feet apart, both looking at a hot air balloon between them. The angles of elevation are $40^\circ$ and $55^\circ$. Find the height of the balloon.'),
    ('Verify that a triangle with sides 8, 15, and 17 is a right triangle, then find its two acute angles.')
) as p(txt)
where s.name = 'Right Triangle Trigonometry' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given that $\theta$ is in the third quadrant and $\sin(\theta) = -\frac{3}{5}$, find $\cos(\theta)$ and $\tan(\theta)$.'),
    ('Find all values of $\theta$ in $[0, 2\pi)$ where $\sin(\theta) = \cos(\theta)$.'),
    ('Use the unit circle to explain why $\cos(-\theta) = \cos(\theta)$ for any angle $\theta$.'),
    ('Find the exact value of $\sin(19\pi/6)$ by first finding a coterminal angle in $[0, 2\pi)$.'),
    ('Determine the sign of $\sin(\theta)\cos(\theta)$ for $\theta$ in the second quadrant, and justify your answer.')
) as p(txt)
where s.name = 'The Unit Circle' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Sketch $y = -2\cos(x) + 1$, identifying the amplitude, midline, and key points over one period.'),
    ('Find a possible equation for a cosine function with amplitude 3, period $\pi$, and a maximum at $x = 0$.'),
    ('Graph $y = \tan(x - \pi/4)$, identifying the phase shift and the equations of two consecutive vertical asymptotes.'),
    ('A Ferris wheel''s height above the ground is modeled by $h(t) = 25\sin\left(\frac{\pi}{15}t - \frac{\pi}{2}\right) + 27$, where $t$ is in seconds. Find the wheel''s minimum and maximum height and its period.'),
    ('Determine the period of $y = \sec(2x)$ and describe how its graph relates to $y=\cos(2x)$.')
) as p(txt)
where s.name = 'Graphs of Trigonometric Functions' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\frac{1 + \tan^2(x)}{\csc^2(x)}$ to a single trig function.'),
    ('Prove the identity $\frac{\sin(x)}{1 - \cos(x)} = \frac{1 + \cos(x)}{\sin(x)}$.'),
    ('Simplify $\sin(x + \pi)$ using the angle sum identity, and verify your answer using the unit circle.'),
    ('Use a sum-to-product identity to rewrite $\sin(5x) + \sin(3x)$ as a product.'),
    ('Prove that $\cos(4x) = 8\cos^4(x) - 8\cos^2(x) + 1$ using double-angle identities twice.'),
    ('Simplify $\frac{\tan(x) + \tan(y)}{1 - \tan(x)\tan(y)}$ by identifying it as a known identity.')
) as p(txt)
where s.name = 'Trigonometric Identities' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $2\cos^2(x) + \cos(x) - 1 = 0$ for $0 \le x < 2\pi$ by factoring as a quadratic in $\cos(x)$.'),
    ('Solve $\sin(2x) = \sin(x)$ for $0 \le x < 2\pi$ using a double-angle identity.'),
    ('Solve $\tan^2(x) - 3 = 0$ for $0 \le x < 2\pi$.'),
    ('Solve $\sin(x) + \cos(x) = 1$ for $0 \le x < 2\pi$.'),
    ('Find all solutions (not restricted to one period) to $\cos(x) = -\frac{1}{2}$, expressing the answer with a $+2\pi n$ term.')
) as p(txt)
where s.name = 'Solving Trigonometric Equations' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Two ships leave port at the same time, one heading $N30^\circ E$ at 15 mph and the other heading $S70^\circ E$ at 20 mph. Find the distance between them after 2 hours.'),
    ('In triangle $ABC$, $a = 7$, $b = 10$, $c = 12$. Find all three angles using the Law of Cosines.'),
    ('Determine whether the given information ($a = 10$, $b = 14$, $\angle A = 30^\circ$) produces zero, one, or two triangles, and solve for any that exist.'),
    ('Find the area of triangle $ABC$ given $a = 8$, $b = 10$, and $\angle C = 50^\circ$.'),
    ('A surveyor measures the angles of elevation to the top of a hill from two points 200 feet apart on level ground, in line with the hill, as $28^\circ$ and $35^\circ$. Find the height of the hill.')
) as p(txt)
where s.name = 'Law of Sines and Law of Cosines' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\cos\left(\arcsin\left(\frac{3}{5}\right)\right)$ without a calculator, using a right triangle.'),
    ('Find the exact value of $\sin\left(2\arctan\left(\frac{1}{2}\right)\right)$ using a double-angle identity.'),
    ('Explain why $\arcsin(\sin(2\pi))$ does not equal $2\pi$, and find its correct value.'),
    ('Solve $\arctan(x) + \arctan(1) = \frac{\pi}{2}$ for $x$.'),
    ('Simplify $\tan(\arccos(x))$ as an expression in $x$.')
) as p(txt)
where s.name = 'Inverse Trigonometric Functions' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Sketch the polar curve $r = 2 + 2\cos(\theta)$ (a cardioid), and identify key points at $\theta = 0, \pi/2, \pi, 3\pi/2$.'),
    ('Convert the rectangular equation $x^2 + y^2 = 6y$ to polar form and simplify.'),
    ('Find all points where the polar curves $r = 1 + \cos\theta$ and $r = 1 - \cos\theta$ intersect.'),
    ('Determine the symmetry of the polar curve $r = 3\sin(2\theta)$, and justify your answer.'),
    ('Convert the point $(-3, 4)$ from rectangular to polar coordinates, giving $r > 0$ and $\theta$ in $[0, 2\pi)$.')
) as p(txt)
where s.name = 'Polar Coordinates' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A plane flies at 300 mph heading due east, with a 40 mph wind blowing from the north. Find the plane''s resulting ground speed and direction.'),
    ('Find a unit vector in the direction of $\vec{v} = \langle -3, 4 \rangle$.'),
    ('Determine whether $\vec{u} = \langle 2, -3 \rangle$ and $\vec{v} = \langle 6, 4 \rangle$ are orthogonal, parallel, or neither.'),
    ('Find the angle between $\vec{u} = \langle 3, 1 \rangle$ and $\vec{v} = \langle 1, 4 \rangle$ using the dot product formula.'),
    ('A force of 50 N is applied at an angle of $30^\circ$ above the horizontal to drag a box. Find the horizontal and vertical components of the force.'),
    ('Given $\vec{u} = \langle 4, -2 \rangle$, decompose $\vec{u}$ into components parallel and perpendicular to $\vec{v} = \langle 1, 1 \rangle$.')
) as p(txt)
where s.name = 'Vectors' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

-- ================= Geometry =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Points $A$, $B$, and $C$ are collinear with $B$ between $A$ and $C$. If $AB = 3x - 2$, $BC = 2x + 5$, and $AC = 33$, find $x$ and the length of $AB$.'),
    ('Determine whether the points $(1,2)$, $(3,6)$, and $(5,10)$ are collinear, using slope.'),
    ('Two planes intersect. Describe what geometric figure their intersection forms, and explain why two distinct planes cannot intersect in just a single point.'),
    ('$M$ is the midpoint of $\overline{AB}$. If $A = (2, -1)$ and $M = (5, 3)$, find the coordinates of $B$.'),
    ('Given three noncollinear points, explain why exactly one plane contains all three.')
) as p(txt)
where s.name = 'Points, Lines, and Planes' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Two parallel lines are cut by a transversal. One same-side interior angle is $3x + 10$ and the other is $2x + 30$. Find $x$ and both angle measures.'),
    ('In the figure formed by two parallel lines cut by a transversal, identify and find the measure of the alternate exterior angle to a given $70^\circ$ angle, explaining the relationship used.'),
    ('Two angles are supplementary, and one is 4 times the other. Find both angle measures.'),
    ('Prove that vertical angles are congruent, using the fact that linear pairs are supplementary.'),
    ('An angle''s measure is three times its complement''s measure. Find the angle.')
) as p(txt)
where s.name = 'Angles and Angle Relationships' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given $\triangle ABC$ and $\triangle DEF$ with $AB \cong DE$, $\angle A \cong \angle D$, and $AC \cong DF$, state which congruence postulate applies and explain why AAS and ASA give the same conclusion in general but SSA does not guarantee congruence.'),
    ('Write a two-column proof that $\triangle ABC \cong \triangle CDA$ given that $AB \parallel CD$, $AB \cong CD$, and $AC$ is a shared side.'),
    ('Determine whether the given information (two sides and a non-included angle) is enough to prove two triangles congruent, and explain why or why not with a counterexample.'),
    ('In isosceles triangle $ABC$ with $AB \cong AC$, prove that the base angles $\angle B$ and $\angle C$ are congruent.'),
    ('Given right triangles with equal hypotenuses and one pair of equal legs, state and justify which congruence postulate applies.')
) as p(txt)
where s.name = 'Triangle Congruence' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Prove that $\triangle ABC \sim \triangle DEF$ given $\angle A \cong \angle D$ and $\angle B \cong \angle E$, and explain why the third angles must also be congruent.'),
    ('A tree casts a 40-foot shadow at the same time a 5-foot person casts an 8-foot shadow. Set up a proportion using similar triangles to find the tree''s height.'),
    ('In $\triangle ABC$, $D$ and $E$ are midpoints of $AB$ and $AC$. Use the Triangle Midsegment Theorem to find $DE$ if $BC = 18$, and explain why $DE \parallel BC$.'),
    ('Given two similar triangles with a scale factor of $\frac{3}{5}$, find the ratio of their areas and the ratio of their perimeters.'),
    ('Use the Angle Bisector Theorem to find $x$ if a triangle has sides 8 and 12 adjacent to the bisected angle, and the bisector divides the opposite side into segments $x$ and $x+3$.')
) as p(txt)
where s.name = 'Triangle Similarity' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A regular polygon has interior angles measuring $156^\circ$ each. Find the number of sides.'),
    ('Prove that the diagonals of a parallelogram bisect each other, using coordinate geometry with $A=(0,0)$, $B=(a,0)$, $C=(a+b,c)$, $D=(b,c)$.'),
    ('Determine whether a quadrilateral with vertices $(0,0)$, $(4,0)$, $(5,3)$, $(1,3)$ is a parallelogram, using slopes.'),
    ('A trapezoid has parallel sides of length 8 and 14, and legs of length 5 each. Find its height (it is isosceles) and its area.'),
    ('Explain the difference between a rhombus, a rectangle, and a square in terms of which properties of a parallelogram each one adds.')
) as p(txt)
where s.name = 'Polygons and Quadrilaterals' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the length of a chord that is 5 cm from the center of a circle with radius 13 cm.'),
    ('Two chords intersect inside a circle, dividing each other into segments of length 4 and 9, and $x$ and 6. Find $x$.'),
    ('Find the measure of an inscribed angle that intercepts an arc of $110^\circ$.'),
    ('A tangent and a secant are drawn from an external point to a circle. If the tangent has length 12 and the external segment of the secant is 8, find the length of the secant''s far segment.'),
    ('Find the equation of a circle with center $(3, -2)$ that passes through $(7, 1)$.')
) as p(txt)
where s.name = 'Circles' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A regular hexagon has side length 6. Find its area using the formula involving the apothem.'),
    ('A composite figure consists of a rectangle 10 by 6 with a semicircle of radius 3 removed from one side. Find its area.'),
    ('Two similar rectangles have a ratio of perimeters of $2:3$. If the area of the smaller is 32, find the area of the larger.'),
    ('Find the area of a regular pentagon with side length 8, given that its apothem is approximately 5.5.'),
    ('A rectangular room is 12 feet by 15 feet. Find the cost to carpet the room if carpet costs 4.50 dollars per square foot.')
) as p(txt)
where s.name = 'Area and Perimeter' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A cone has a slant height of 13 and a radius of 5. Find its surface area and volume.'),
    ('Two similar spheres have radii in a ratio of $2:5$. Find the ratio of their volumes.'),
    ('A water tank is a cylinder with radius 4 feet and height 10 feet, capped by a hemisphere on top. Find the total volume of the tank.'),
    ('A rectangular prism has volume 240 and a square base with side length 6. Find its height and total surface area.'),
    ('Explain why doubling all the dimensions of a solid multiplies its surface area by 4 but its volume by 8, using a cube as an example.')
) as p(txt)
where s.name = 'Surface Area and Volume' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the equation of the perpendicular bisector of the segment from $(2, 5)$ to $(8, -1)$.'),
    ('A triangle has vertices $(0,0)$, $(6,0)$, and $(3,5)$. Determine whether it is scalene, isosceles, or equilateral using the distance formula.'),
    ('Find the point that divides the segment from $(-2, 4)$ to $(6, -8)$ in a $2:1$ ratio.'),
    ('Prove that the quadrilateral with vertices $(0,0)$, $(5,0)$, $(5,5)$, $(0,5)$ is a square, using both distance and slope.'),
    ('Find the center and radius of the circle passing through $(0,0)$, $(0,6)$, and $(8,0)$.')
) as p(txt)
where s.name = 'Coordinate Geometry' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Triangle $ABC$ with vertices $A(1,2)$, $B(4,2)$, $C(4,5)$ is dilated by a scale factor of 2 centered at the origin, then reflected over the $y$-axis. Find the coordinates of the final image.'),
    ('Determine the single transformation equivalent to reflecting a figure over the $x$-axis and then over the $y$-axis.'),
    ('A figure is rotated $180^\circ$ about the point $(2, 3)$. Find the image of the point $(5, 3)$.'),
    ('Determine whether the composition of two reflections over parallel lines is a translation or a rotation, and describe it.'),
    ('Given a triangle and its image after a glide reflection, describe the two individual transformations that make up a glide reflection.')
) as p(txt)
where s.name = 'Transformations' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

-- ================= Calculus 1 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\lim_{x \to 0} \frac{\sin(3x)}{x}$ using the fact that $\lim_{x\to 0} \frac{\sin x}{x} = 1$.'),
    ('Determine the value of $k$ that makes $f(x) = \begin{cases} x^2 + k & x < 2 \\ 3x & x \ge 2\end{cases}$ continuous at $x = 2$.'),
    ('Evaluate $\lim_{x \to \infty} \frac{3x^2 - 2x}{5x^2 + 1}$.'),
    ('Evaluate $\lim_{x \to 2} \frac{x^2 - x - 2}{x^2 - 4}$, noting that direct substitution gives $0/0$.'),
    ('Determine where $f(x) = \frac{x+3}{x^2 - 9}$ is discontinuous, and classify each discontinuity as removable or non-removable.'),
    ('Use the Intermediate Value Theorem to show that $f(x) = x^3 - x - 1$ has a root between $x = 1$ and $x = 2$.'),
    ('Evaluate $\lim_{x \to 0} x^2\sin(1/x)$ using the Squeeze Theorem.')
) as p(txt)
where s.name = 'Limits and Continuity' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Use the limit definition to find $f''(x)$ for $f(x) = \sqrt{x}$.'),
    ('Use the limit definition to find $f''(x)$ for $f(x) = \frac{1}{x}$.'),
    ('Explain, using the limit definition of the derivative, why $f(x) = |x|$ is not differentiable at $x = 0$.'),
    ('Use the limit definition to show that the derivative of a constant function is 0.'),
    ('Use the alternate limit definition $f''(a) = \lim_{x\to a}\frac{f(x)-f(a)}{x-a}$ to find $f''(3)$ for $f(x) = x^2 - 2x$.')
) as p(txt)
where s.name = 'The Derivative Definition' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find $\frac{dy}{dx}$ for $y = \frac{x^2 + 1}{x - 3}$ using the quotient rule.'),
    ('Find the derivative of $y = \sqrt{x^2 + 1}$ using the chain rule.'),
    ('Find $\frac{dy}{dx}$ for $x^2 + y^2 = 25$ using implicit differentiation.'),
    ('Find the second derivative of $f(x) = x^4 - 3x^2 + 2x$.'),
    ('Find $\frac{dy}{dx}$ for $y = \sin(x)\cos(x)$ using the product rule, then verify using a double-angle identity.'),
    ('Use implicit differentiation to find $\frac{dy}{dx}$ for $x^3 + y^3 = 6xy$.'),
    ('Find the derivative of $y = (2x+1)^3(x-4)^2$ using the product and chain rules.')
) as p(txt)
where s.name = 'Differentiation Rules' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the intervals where $f(x) = x^3 - 3x^2 - 9x + 5$ is increasing and decreasing, and identify any local extrema.'),
    ('Find the intervals of concavity and any inflection points of $f(x) = x^4 - 6x^2$.'),
    ('Use the First Derivative Test to classify the critical points of $f(x) = x^3 - 12x$.'),
    ('Use the Second Derivative Test to classify the critical points of $f(x) = x^4 - 4x^3$.'),
    ('Find the linear approximation of $f(x) = \sqrt{x}$ at $x = 25$, and use it to estimate $\sqrt{26}$.'),
    ('Sketch the graph of a function that is increasing and concave down everywhere, and give a possible formula for it.')
) as p(txt)
where s.name = 'Applications of Derivatives' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A conical tank with radius 3 ft and height 10 ft is being filled with water at $2 \text{ft}^3$/min. Find how fast the water level is rising when the water is 4 ft deep.'),
    ('Two cars leave an intersection at the same time, one heading north at 40 mph and the other east at 30 mph. Find how fast the distance between them is increasing after 1 hour.'),
    ('A camera on the ground tracks a rocket launching straight up at 500 ft/s. Find how fast the angle of elevation of the camera is changing when the rocket is 1000 feet high and the camera is 3000 feet from the launch pad.'),
    ('The area of a circular oil slick is increasing at 6 square meters per minute. Find how fast the radius is increasing when the radius is 10 m.'),
    ('A person 6 feet tall walks away from a 15-foot lamppost at 4 ft/s. Find how fast the tip of their shadow is moving.')
) as p(txt)
where s.name = 'Related Rates' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A cylindrical can must hold 500 cubic centimeters. Find the dimensions that minimize the amount of material used.'),
    ('Find the point on the line $y = 2x + 1$ closest to the point $(3, 0)$.'),
    ('A farmer has 400 feet of fencing to enclose a rectangular field, then divide it in half with a fence parallel to one side. Find the dimensions that maximize the total enclosed area.'),
    ('Find the dimensions of the rectangle of maximum area that can be inscribed in a semicircle of radius 5.'),
    ('A box with a square base and open top must have a volume of $32{,}000 \text{cm}^3$. Find the dimensions that minimize the surface area.')
) as p(txt)
where s.name = 'Optimization Problems' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Verify that $f(x) = \sin(x)$ satisfies the hypotheses of the Mean Value Theorem on $[0, \pi]$, and find all values of $c$ that satisfy the conclusion.'),
    ('Explain why the Mean Value Theorem does not apply to $f(x) = |x|$ on $[-1, 1]$, and identify which hypothesis fails.'),
    ('Use the Mean Value Theorem to show that $|\sin(a) - \sin(b)| \le |a - b|$ for all real $a$ and $b$.'),
    ('A car travels 150 miles in 2 hours. Use the Mean Value Theorem to argue that the car''s speed was exactly 75 mph at some instant.'),
    ('Determine whether $f(x) = x^{2/3}$ satisfies the hypotheses of the Mean Value Theorem on $[-1, 1]$, and explain why or why not.')
) as p(txt)
where s.name = 'The Mean Value Theorem' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find $f(x)$ given that $f''(x) = 3x^2 - 4x + 1$ and $f(1) = 5$.'),
    ('Find $\int \sec^2(x)\,dx$ and $\int \sec(x)\tan(x)\,dx$, and explain how you know these are correct without integration by parts.'),
    ('Find the general antiderivative of $f(x) = \frac{2}{x} + 3e^x$.'),
    ('A particle has acceleration $a(t) = 6t - 4$, initial velocity $v(0) = 3$, and initial position $s(0) = 0$. Find the position function $s(t)$.'),
    ('Find $\int \frac{x^2 + 1}{x}\,dx$ by first dividing.'),
    ('Explain why $\int \frac{1}{x}\,dx = \ln|x| + C$ requires the absolute value, using the domain of $\frac{1}{x}$.')
) as p(txt)
where s.name = 'Antiderivatives and Indefinite Integrals' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Use the definition of the definite integral as a limit of Riemann sums to set up (but not necessarily evaluate) $\int_0^2 x^2\,dx$ using right endpoints.'),
    ('Use geometry (not antiderivatives) to evaluate $\int_{-2}^2 \sqrt{4-x^2}\,dx$.'),
    ('If $\int_0^5 f(x)\,dx = 8$ and $\int_3^5 f(x)\,dx = 3$, find $\int_0^3 f(x)\,dx$.'),
    ('Estimate $\int_0^4 f(x)\,dx$ using the Midpoint Rule with 4 subintervals, given a table of values for $f$ at $x = 0.5, 1.5, 2.5, 3.5$.'),
    ('Evaluate $\int_{-3}^3 (x^3 - 2x)\,dx$ using symmetry, without computing an antiderivative value at each bound.')
) as p(txt)
where s.name = 'The Definite Integral' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find $\frac{d}{dx}\int_1^{x^2} \sqrt{t^2+1}\,dt$ using the Chain Rule together with the Fundamental Theorem.'),
    ('Evaluate $\int_1^4 (3\sqrt{x} - 2)\,dx$ using the Fundamental Theorem.'),
    ('Given $F(x) = \int_0^x f(t)\,dt$ and a description of $f$, determine the intervals where $F$ is increasing and where $F$ is concave up.'),
    ('Find $\frac{d}{dx}\int_{x}^{5} \cos(t^2)\,dt$ (variable in the lower limit).'),
    ('Use the Fundamental Theorem to explain why differentiation and integration are inverse processes, illustrating with $\int_a^x f(t)\,dt$.')
) as p(txt)
where s.name = 'The Fundamental Theorem of Calculus' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

-- ================= Linear Algebra =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve the system $x + 2y - z = 3$, $2x - y + z = 1$, $x + y + 2z = 4$ using Gaussian elimination.'),
    ('Write the augmented matrix for the system $2x - y = 5$, $x + 3y = -1$, and reduce it to row-echelon form.'),
    ('Determine whether the system $x + y = 3$, $2x + 2y = 7$ is consistent, and explain what this means geometrically.'),
    ('Solve the system $x - y + z = 0$, $2x + y - z = 3$, $-x + 2y + z = 5$, and classify the solution as unique, none, or infinitely many.'),
    ('A system has augmented matrix $\begin{pmatrix} 1 & 2 & | & 3 \\ 0 & 0 & | & 0 \end{pmatrix}$ after row reduction. Describe the solution set.')
) as p(txt)
where s.name = 'Systems of Linear Equations and Matrices' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given $A$ is $2\times 3$ and $B$ is $3\times 2$, find the dimensions of $AB$ and $BA$, and explain why they are generally not equal.'),
    ('Given $A = \begin{pmatrix}1&2\\3&4\end{pmatrix}$, find $A^2$ and $A^3$.'),
    ('Determine whether matrix multiplication is commutative in general, using a specific $2\times2$ example where $AB \ne BA$.'),
    ('Find $A^{-1}$ for $A = \begin{pmatrix}2&1\\5&3\end{pmatrix}$ using the $2\times2$ inverse formula, and verify $AA^{-1}=I$.'),
    ('Given $A$, $B$, and $C$ are $2\times2$ matrices, determine whether $(AB)C = A(BC)$ always, and state the property this illustrates.')
) as p(txt)
where s.name = 'Matrix Operations' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the determinant of $\begin{pmatrix}2&0&1\\-1&3&2\\0&1&4\end{pmatrix}$ using cofactor expansion.'),
    ('Explain how a determinant of 0 relates to whether a matrix is invertible, using $\begin{pmatrix}2&4\\1&2\end{pmatrix}$ as an example.'),
    ('Find the area of the parallelogram formed by vectors $(3,1)$ and $(1,4)$ using a determinant.'),
    ('Use the property that swapping two rows negates the determinant to find $\det(B)$ given $\det(A) = 5$, where $B$ is $A$ with rows 1 and 2 swapped.'),
    ('Find the determinant of a $3\times3$ upper triangular matrix and explain why it equals the product of the diagonal entries in general.')
) as p(txt)
where s.name = 'Determinants' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether the set of all polynomials of degree exactly 2 forms a vector space, explaining which axiom fails if it does not.'),
    ('Determine whether $(2, -1, 3)$ is in the span of $\{(1,0,1), (0,1,1)\}$.'),
    ('Show that the set of solutions to $x + 2y - z = 0$ forms a subspace of $\mathbb{R}^3$, by verifying closure under addition and scalar multiplication.'),
    ('Determine whether the vectors $(1,2,3)$, $(0,1,2)$, $(1,0,-1)$ span $\mathbb{R}^3$.'),
    ('Explain why the zero vector must belong to every subspace, using the subspace test.')
) as p(txt)
where s.name = 'Vector Spaces' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether $\{(1,1,0), (0,1,1), (1,0,1)\}$ is linearly independent, and if so, explain why it forms a basis for $\mathbb{R}^3$.'),
    ('Find a basis for the subspace of $\mathbb{R}^3$ spanned by $(1,2,1)$, $(2,4,2)$, and $(1,0,1)$.'),
    ('Determine the dimension of the solution space to $x + y + z = 0$ in $\mathbb{R}^3$, and give a basis for it.'),
    ('Extend $\{(1,0,0), (1,1,0)\}$ to a basis of $\mathbb{R}^3$.'),
    ('Explain why any set of 4 vectors in $\mathbb{R}^3$ must be linearly dependent.')
) as p(txt)
where s.name = 'Linear Independence and Basis' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether $T(x,y) = (x+1, y)$ is a linear transformation, and justify your answer using the definition.'),
    ('Find the standard matrix for the transformation that rotates vectors in $\mathbb{R}^2$ by $90^\circ$ counterclockwise.'),
    ('Given $T(x,y,z) = (x+y, y-z, x+z)$, find the matrix of $T$ and determine whether $T$ is invertible.'),
    ('Determine the kernel of the linear transformation with matrix $\begin{pmatrix}1&2\\2&4\end{pmatrix}$.'),
    ('Find the standard matrix for the composition of a reflection over the $x$-axis followed by a $90^\circ$ rotation.')
) as p(txt)
where s.name = 'Linear Transformations' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the eigenvalues and corresponding eigenvectors of $A = \begin{pmatrix}4&1\\2&3\end{pmatrix}$.'),
    ('Determine whether $\lambda = 2$ is an eigenvalue of $A = \begin{pmatrix}3&-1\\1&1\end{pmatrix}$, and if so, find its eigenvector.'),
    ('Find the eigenvalues of the $3\times3$ matrix $\begin{pmatrix}2&0&0\\0&3&1\\0&1&3\end{pmatrix}$, using the block structure to simplify the work.'),
    ('Explain what it means geometrically for a real matrix to have complex eigenvalues, using $\begin{pmatrix}0&-1\\1&0\end{pmatrix}$ as an example.'),
    ('Given that a $2\times2$ matrix has eigenvalues 2 and 5, find its trace and determinant.')
) as p(txt)
where s.name = 'Eigenvalues and Eigenvectors' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Use the Gram-Schmidt process to find an orthogonal basis from $\{(1,1,0), (1,0,1)\}$.'),
    ('Find the least-squares line that best fits the points $(1,2)$, $(2,3)$, $(3,5)$, $(4,6)$ by setting up and solving the normal equations.'),
    ('Determine whether the columns of $A = \begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix}$ are orthogonal, and if not, apply Gram-Schmidt to orthogonalize them.'),
    ('Find the orthogonal projection of $\vec{b} = (1,2,2)$ onto the plane spanned by $(1,0,0)$ and $(0,1,0)$.'),
    ('Explain why the least-squares solution minimizes $\|A\vec{x} - \vec{b}\|$, and what the normal equations $A^TA\vec{x} = A^T\vec{b}$ represent.')
) as p(txt)
where s.name = 'Orthogonality and Least Squares' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Diagonalize $A = \begin{pmatrix}2&1\\1&2\end{pmatrix}$, finding $P$ and $D$ such that $A = PDP^{-1}$.'),
    ('Use diagonalization to compute $A^{10}$ for $A = \begin{pmatrix}4&0\\0&-1\end{pmatrix}$.'),
    ('Explain why a matrix with a repeated eigenvalue might not be diagonalizable, using $\begin{pmatrix}2&1\\0&2\end{pmatrix}$ as an example.'),
    ('Given $A = \begin{pmatrix}3&-2\\-2&3\end{pmatrix}$, diagonalize it and verify that $A = PDP^{-1}$ by direct multiplication.'),
    ('Determine whether every symmetric matrix is diagonalizable, and state the theorem that guarantees this.')
) as p(txt)
where s.name = 'Diagonalization' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A Markov chain models weather as sunny or rainy, with transition matrix $\begin{pmatrix}0.9&0.5\\0.1&0.5\end{pmatrix}$. Find the long-run steady-state distribution by solving for the eigenvector with eigenvalue 1.'),
    ('Use matrices to find the equilibrium population distribution in a two-habitat migration model where 20% of habitat A''s population moves to B each year, and 10% of B''s moves to A.'),
    ('Encode the message "HI" as numbers (H=8, I=9) into a vector, and encrypt it by multiplying by the matrix $\begin{pmatrix}1&2\\1&1\end{pmatrix}$, then find the matrix needed to decrypt it.'),
    ('In a simple economic input-output model with two sectors, given a matrix of inter-sector demand, set up and solve for the production levels needed to meet external demand of $(100, 150)$.'),
    ('Explain how eigenvalues of a Markov transition matrix relate to whether the system reaches a stable long-term distribution.')
) as p(txt)
where s.name = 'Applications of Linear Algebra' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');
