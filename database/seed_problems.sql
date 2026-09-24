-- Clears all existing problems and generates 15 topic-appropriate problems per section.
-- WARNING: destructive. DELETE FROM problem cascades to user_problem_attempt (ON DELETE
-- CASCADE), so any recorded attempt history tied to existing problems is removed too.
-- Run this in the Supabase SQL editor against your live project.

delete from public.problem;

-- ================= Algebra 1 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $3x + 2y$ when $x = -1$ and $y = -2$.'),
    ('Evaluate $5x + 4y$ when $x = -4$ and $y = 5$.'),
    ('Evaluate $3x + 8y$ when $x = -5$ and $y = -5$.'),
    ('Evaluate $3x + 5y$ when $x = -2$ and $y = 3$.'),
    ('Evaluate $2x + 5y$ when $x = 5$ and $y = 3$.'),
    ('Evaluate $8x + 5y$ when $x = 2$ and $y = 4$.'),
    ('Evaluate $6x + 2y$ when $x = -3$ and $y = 1$.'),
    ('Evaluate $7x + 6y$ when $x = -3$ and $y = -2$.'),
    ('Evaluate $7x + 3y$ when $x = -4$ and $y = 1$.'),
    ('Evaluate $3x + 7y$ when $x = 4$ and $y = -1$.'),
    ('Evaluate $2x + 9y$ when $x = 3$ and $y = -4$.'),
    ('Evaluate $8x + 3y$ when $x = 3$ and $y = -1$.'),
    ('Evaluate $7x + 5y$ when $x = -4$ and $y = -5$.'),
    ('Evaluate $5x + 6y$ when $x = -4$ and $y = -2$.'),
    ('Evaluate $3x + 8y$ when $x = -1$ and $y = 2$.')
) as p(txt)
where s.name = 'Variables and Expressions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve for $x$: $12x + 11 = 3$.'),
    ('Solve for $x$: $4x - 4 = 2$.'),
    ('Solve for $x$: $5x + 6 = -3$.'),
    ('Solve for $x$: $12x + 5 = -16$.'),
    ('Solve for $x$: $11x + 5 = -10$.'),
    ('Solve for $x$: $10x + 8 = -5$.'),
    ('Solve for $x$: $4x - 1 = 4$.'),
    ('Solve for $x$: $6x + 14 = 20$.'),
    ('Solve for $x$: $10x - 8 = -17$.'),
    ('Solve for $x$: $5x + 11 = -18$.'),
    ('Solve for $x$: $7x - 3 = -3$.'),
    ('Solve for $x$: $3x - 9 = 16$.'),
    ('Solve for $x$: $7x - 9 = 11$.'),
    ('Solve for $x$: $8x + 13 = 9$.'),
    ('Solve for $x$: $4x - 7 = -12$.')
) as p(txt)
where s.name = 'Solving Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve for $x$: $5x - 11 < 15$.'),
    ('Solve for $x$: $8x - 6 < 5$.'),
    ('Solve for $x$: $5x + 8 > 12$.'),
    ('Solve for $x$: $3x - 12 \le -17$.'),
    ('Solve for $x$: $4x - 8 > -10$.'),
    ('Solve for $x$: $3x - 7 < 9$.'),
    ('Solve for $x$: $10x + 12 < -13$.'),
    ('Solve for $x$: $7x + 9 > -2$.'),
    ('Solve for $x$: $4x - 2 < -20$.'),
    ('Solve for $x$: $10x - 12 \le -9$.'),
    ('Solve for $x$: $6x - 8 \ge 12$.'),
    ('Solve for $x$: $4x + 1 \le -10$.'),
    ('Solve for $x$: $7x - 3 \le -19$.'),
    ('Solve for $x$: $7x + 3 \le -5$.'),
    ('Solve for $x$: $5x - 6 \le -15$.')
) as p(txt)
where s.name = 'Solving Linear Inequalities' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the slope and $y$-intercept of $y = 5x + 5$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -5x + 7$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 6x - 6$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -4x + 5$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 2x - 5$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -2x + 6$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 3x + 3$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -3x + 7$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 6x - 4$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 5x - 1$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 4x + 10$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -x + 4$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = 2x + 4$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -5x - 3$, and describe how to graph the line.'),
    ('Find the slope and $y$-intercept of $y = -3x - 8$, and describe how to graph the line.')
) as p(txt)
where s.name = 'Graphing Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Write the equation of the line that passes through $(2, -8)$ and $(-1, -1)$.'),
    ('Write the equation of the line that passes through $(-8, -6)$ and $(-7, -1)$.'),
    ('Write the equation of the line that passes through $(-6, -7)$ and $(2, -6)$.'),
    ('Write the equation of the line that passes through $(8, -1)$ and $(7, -2)$.'),
    ('Write the equation of the line that passes through $(-4, 7)$ and $(-1, 7)$.'),
    ('Write the equation of the line that passes through $(5, -2)$ and $(-5, -5)$.'),
    ('Write the equation of the line that passes through $(5, 3)$ and $(6, -7)$.'),
    ('Write the equation of the line that passes through $(-5, -7)$ and $(4, 2)$.'),
    ('Write the equation of the line that passes through $(-5, -1)$ and $(-2, -2)$.'),
    ('Write the equation of the line that passes through $(6, -4)$ and $(5, -3)$.'),
    ('Write the equation of the line that passes through $(6, -1)$ and $(-6, 6)$.'),
    ('Write the equation of the line that passes through $(-5, -7)$ and $(-8, -6)$.'),
    ('Write the equation of the line that passes through $(-1, -3)$ and $(5, 7)$.'),
    ('Write the equation of the line that passes through $(7, -2)$ and $(4, -7)$.'),
    ('Write the equation of the line that passes through $(-3, 4)$ and $(-8, 4)$.')
) as p(txt)
where s.name = 'Writing Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve the system of equations: $-x + 5y = 4$ and $8x + 6y = -5$.'),
    ('Solve the system of equations: $-3x - 3y = -8$ and $9x + 8y = -8$.'),
    ('Solve the system of equations: $x - 8y = -8$ and $9x + 6y = 7$.'),
    ('Solve the system of equations: $7x - 4y = -8$ and $7x - 7y = -4$.'),
    ('Solve the system of equations: $-7x - 7y = -2$ and $3x - 6y = 9$.'),
    ('Solve the system of equations: $-2x + 9y = -8$ and $-7x + 4y = 9$.'),
    ('Solve the system of equations: $9x + 7y = 1$ and $-x - 3y = 1$.'),
    ('Solve the system of equations: $-2x - y = 3$ and $-5x + 5y = 1$.'),
    ('Solve the system of equations: $-7x - 9y = 5$ and $9x - 6y = -7$.'),
    ('Solve the system of equations: $8x - 3y = 7$ and $-x - 5y = 2$.'),
    ('Solve the system of equations: $-7x - 2y = 2$ and $-4x + 5y = 8$.'),
    ('Solve the system of equations: $7x - 9y = 8$ and $-6x - 5y = -1$.'),
    ('Solve the system of equations: $-6x - 6y = 8$ and $-5x - y = -3$.'),
    ('Solve the system of equations: $x - 3y = -1$ and $7x + 6y = -1$.'),
    ('Solve the system of equations: $-8x - 7y = 4$ and $-x - 8y = -9$.')
) as p(txt)
where s.name = 'Systems of Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $4^{3} \cdot 4^{4}$, then write the result as a single power of 4.'),
    ('Simplify $3^{5} \cdot 3^{6}$, then write the result as a single power of 3.'),
    ('Simplify $5^{6} \cdot 5^{2}$, then write the result as a single power of 5.'),
    ('Simplify $2^{2} \cdot 2^{3}$, then write the result as a single power of 2.'),
    ('Simplify $6^{2} \cdot 6^{4}$, then write the result as a single power of 6.'),
    ('Simplify $6^{6} \cdot 6^{3}$, then write the result as a single power of 6.'),
    ('Simplify $5^{3} \cdot 5^{2}$, then write the result as a single power of 5.'),
    ('Simplify $4^{4} \cdot 4^{2}$, then write the result as a single power of 4.'),
    ('Simplify $4^{3} \cdot 4^{3}$, then write the result as a single power of 4.'),
    ('Simplify $2^{4} \cdot 2^{6}$, then write the result as a single power of 2.'),
    ('Simplify $5^{6} \cdot 5^{3}$, then write the result as a single power of 5.'),
    ('Simplify $3^{3} \cdot 3^{3}$, then write the result as a single power of 3.'),
    ('Simplify $5^{2} \cdot 5^{3}$, then write the result as a single power of 5.'),
    ('Simplify $4^{5} \cdot 4^{3}$, then write the result as a single power of 4.'),
    ('Simplify $4^{3} \cdot 4^{2}$, then write the result as a single power of 4.')
) as p(txt)
where s.name = 'Exponents and Exponential Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Factor the polynomial $x^2 - 5x - 24$.'),
    ('Factor the polynomial $x^2 + 4x - 12$.'),
    ('Factor the polynomial $x^2 + 2x - 15$.'),
    ('Factor the polynomial $x^2 + 0x - 4$.'),
    ('Factor the polynomial $x^2 - 11x + 18$.'),
    ('Factor the polynomial $x^2 + 0x - 9$.'),
    ('Factor the polynomial $x^2 + 0x - 1$.'),
    ('Factor the polynomial $x^2 - 8x + 7$.'),
    ('Factor the polynomial $x^2 + 9x + 14$.'),
    ('Factor the polynomial $x^2 + 11x + 24$.'),
    ('Factor the polynomial $x^2 - 8x - 9$.'),
    ('Factor the polynomial $x^2 - 7x + 6$.'),
    ('Factor the polynomial $x^2 + 5x - 36$.'),
    ('Factor the polynomial $x^2 - 9x + 8$.'),
    ('Factor the polynomial $x^2 - 2x - 24$.')
) as p(txt)
where s.name = 'Polynomials and Factoring' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $3x^2 + 11x + 10 = 0$ using the quadratic formula.'),
    ('Solve $3x^2 + x + 4 = 0$ using the quadratic formula.'),
    ('Solve $5x^2 - 9x - 3 = 0$ using the quadratic formula.'),
    ('Solve $5x^2 - 6x - 7 = 0$ using the quadratic formula.'),
    ('Solve $x^2 + 10x - 2 = 0$ using the quadratic formula.'),
    ('Solve $x^2 + 4x + 14 = 0$ using the quadratic formula.'),
    ('Solve $5x^2 + 9x + 8 = 0$ using the quadratic formula.'),
    ('Solve $2x^2 - x - 2 = 0$ using the quadratic formula.'),
    ('Solve $x^2 + 9x + 14 = 0$ using the quadratic formula.'),
    ('Solve $3x^2 + 7x - 5 = 0$ using the quadratic formula.'),
    ('Solve $x^2 + 11x + 13 = 0$ using the quadratic formula.'),
    ('Solve $3x^2 + 4x - 6 = 0$ using the quadratic formula.'),
    ('Solve $4x^2 - 2x - 3 = 0$ using the quadratic formula.'),
    ('Solve $3x^2 + 5x - 11 = 0$ using the quadratic formula.'),
    ('Solve $2x^2 + x + 6 = 0$ using the quadratic formula.')
) as p(txt)
where s.name = 'Quadratic Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\sqrt{99}$ as far as possible.'),
    ('Simplify $\sqrt{175}$ as far as possible.'),
    ('Simplify $\sqrt{193}$ as far as possible.'),
    ('Simplify $\sqrt{46}$ as far as possible.'),
    ('Simplify $\sqrt{159}$ as far as possible.'),
    ('Simplify $\sqrt{147}$ as far as possible.'),
    ('Simplify $\sqrt{79}$ as far as possible.'),
    ('Simplify $\sqrt{105}$ as far as possible.'),
    ('Simplify $\sqrt{142}$ as far as possible.'),
    ('Simplify $\sqrt{2}$ as far as possible.'),
    ('Simplify $\sqrt{79}$ as far as possible.'),
    ('Simplify $\sqrt{75}$ as far as possible.'),
    ('Simplify $\sqrt{55}$ as far as possible.'),
    ('Simplify $\sqrt{112}$ as far as possible.'),
    ('Simplify $\sqrt{150}$ as far as possible.')
) as p(txt)
where s.name = 'Radical Expressions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 1');

-- ================= Calculus 2 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int x \cos(5x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x^2 e^{4x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x \sin(4x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x^2 e^{5x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x e^{2x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x \cos(3x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x \sin(x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x \sin(3x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x \sin(2x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x e^{x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x^2 e^{2x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x e^{5x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x^2 e^{4x}\,dx$ using integration by parts.'),
    ('Evaluate $\int x \sin(5x)\,dx$ using integration by parts.'),
    ('Evaluate $\int x^2 e^{4x}\,dx$ using integration by parts.')
) as p(txt)
where s.name = 'Integration by Parts' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int \sin^{2}(x)\cos(x)\,dx$.'),
    ('Evaluate $\int \sin^{2}(x)\cos(x)\,dx$.'),
    ('Evaluate $\int \sin^{2}(x)\cos(x)\,dx$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{6^2 - x^2}}$.'),
    ('Evaluate $\int \sin^{2}(x)\cos(x)\,dx$.'),
    ('Evaluate $\int \sin^{3}(x)\cos(x)\,dx$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{6^2 - x^2}}$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{4^2 - x^2}}$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{5^2 - x^2}}$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{2^2 - x^2}}$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{4^2 - x^2}}$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{2^2 - x^2}}$.'),
    ('Use trigonometric substitution to evaluate $\int \frac{dx}{\sqrt{5^2 - x^2}}$.'),
    ('Evaluate $\int \sin^{3}(x)\cos(x)\,dx$.'),
    ('Evaluate $\int \sin^{4}(x)\cos(x)\,dx$.')
) as p(txt)
where s.name = 'Trigonometric Integrals and Substitution' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Decompose $\frac{1}{(x+5)(x+4)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+5)(x+6)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+6)(x+2)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+3)(x+4)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+7)(x+3)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+4)(x+2)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+7)(x+6)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+8)(x+7)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+1)(x+4)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+7)(x+1)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+7)(x+8)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+1)(x+6)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+5)(x+7)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+7)(x+4)}$ into partial fractions.'),
    ('Decompose $\frac{1}{(x+8)(x+4)}$ into partial fractions.')
) as p(txt)
where s.name = 'Partial Fraction Decomposition' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{4}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{2}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{4}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{3}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{3}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{2}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{2}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{2}}\,dx$, or show it diverges.'),
    ('Evaluate $\int_{1}^{\infty} \frac{1}{x^{5}}\,dx$, or show it diverges.')
) as p(txt)
where s.name = 'Improper Integrals' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 4$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 1$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 4$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 2$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 3$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 4$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 4$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 1$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{3}$ and $y = 1$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 3$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 1$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 1$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 2$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 2$ is rotated about the $x$-axis.'),
    ('Find the volume of the solid formed when the region bounded by $y = x^{2}$ and $y = 2$ is rotated about the $x$-axis.')
) as p(txt)
where s.name = 'Applications of Integration: Area and Volume' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the arc length of $y = 4x^2$ from $x = 0$ to $x = 1$.'),
    ('Find the arc length of $y = 2x^2$ from $x = 0$ to $x = 4$.'),
    ('Find the arc length of $y = 3x^2$ from $x = 0$ to $x = 3$.'),
    ('Find the arc length of $y = 2x^2$ from $x = 0$ to $x = 5$.'),
    ('Find the arc length of $y = x^2$ from $x = 0$ to $x = 2$.'),
    ('Find the arc length of $y = 3x^2$ from $x = 0$ to $x = 1$.'),
    ('Find the arc length of $y = x^2$ from $x = 0$ to $x = 3$.'),
    ('Find the arc length of $y = 4x^2$ from $x = 0$ to $x = 4$.'),
    ('Find the arc length of $y = 2x^2$ from $x = 0$ to $x = 1$.'),
    ('Find the arc length of $y = 2x^2$ from $x = 0$ to $x = 1$.'),
    ('Find the arc length of $y = 3x^2$ from $x = 0$ to $x = 5$.'),
    ('Find the arc length of $y = x^2$ from $x = 0$ to $x = 5$.'),
    ('Find the arc length of $y = x^2$ from $x = 0$ to $x = 3$.'),
    ('Find the arc length of $y = 4x^2$ from $x = 0$ to $x = 3$.'),
    ('Find the arc length of $y = x^2$ from $x = 0$ to $x = 5$.')
) as p(txt)
where s.name = 'Arc Length and Surface Area' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether the sequence $a_n = \frac{6n - 9}{7n + 6}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{2n + 4}{6n + 5}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{3n + 4}{3n + 7}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{5n + 8}{8n + 5}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{7n + 9}{5n + 1}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{4n - 7}{5n + 5}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{4n + 5}{7n + 1}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{n + 6}{6n - 4}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{8n - 3}{6n - 1}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{6n - 1}{5n + 8}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{n + 7}{4n - 7}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{4n + 4}{8n + 8}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{4n + 6}{8n + 5}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{n - 7}{5n - 2}$ converges, and if so, find its limit.'),
    ('Determine whether the sequence $a_n = \frac{7n - 2}{5n + 9}$ converges, and if so, find its limit.')
) as p(txt)
where s.name = 'Sequences and Their Limits' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Use the ratio test to determine whether $\sum_{n=1}^{\infty} \frac{n!}{4^n}$ converges.'),
    ('Use the ratio test to determine whether $\sum_{n=1}^{\infty} \frac{n!}{4^n}$ converges.'),
    ('Use the ratio test to determine whether $\sum_{n=1}^{\infty} \frac{n!}{4^n}$ converges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{3}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{1}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{3}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{5}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{2}}$ converges or diverges.'),
    ('Use the ratio test to determine whether $\sum_{n=1}^{\infty} \frac{n!}{4^n}$ converges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{1}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{3}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{3}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{3}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{5}}$ converges or diverges.'),
    ('Determine whether $\sum_{n=1}^{\infty} \frac{1}{n^{3}}$ converges or diverges.')
) as p(txt)
where s.name = 'Infinite Series and Convergence Tests' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--5)^n}{6^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--1)^n}{3^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-5)^n}{5^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--4)^n}{2^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-4)^n}{4^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-2)^n}{5^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-2)^n}{4^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--3)^n}{2^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--1)^n}{5^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--4)^n}{2^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-1)^n}{5^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--4)^n}{6^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-5)^n}{2^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x--3)^n}{3^n}$.'),
    ('Find the radius of convergence of $\sum_{n=0}^{\infty} \frac{(x-4)^n}{4^n}$.')
) as p(txt)
where s.name = 'Power Series and Radius of Convergence' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \sin(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \frac{1}{1-x}$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \frac{1}{1-x}$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \frac{1}{1-x}$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \ln(1+x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \cos(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \cos(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \frac{1}{1-x}$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \sin(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \cos(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \sin(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \sin(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \sin(x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \ln(1+x)$ centered at $x = 0$.'),
    ('Find the first four nonzero terms of the Taylor series for $f(x) = \frac{1}{1-x}$ centered at $x = 0$.')
) as p(txt)
where s.name = 'Taylor Series' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 2');

-- ================= Algebra 2 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve for $x$: $9(x - 6) = 2x - 8$.'),
    ('Solve for $x$: $6(x + 7) = 6x + 7$.'),
    ('Solve for $x$: $9(x - 13) = 5x + 14$.'),
    ('Solve for $x$: $6(x + 10) = 5x - 2$.'),
    ('Solve for $x$: $3(x + 2) = 5x + 5$.'),
    ('Solve for $x$: $4(x + 14) = 6x + 11$.'),
    ('Solve for $x$: $4(x - 13) = 2x - 10$.'),
    ('Solve for $x$: $6(x + 4) = 6x - 1$.'),
    ('Solve for $x$: $3(x - 1) = 6x + 7$.'),
    ('Solve for $x$: $8(x + 15) = 6x + 1$.'),
    ('Solve for $x$: $9(x - 1) = 3x + 4$.'),
    ('Solve for $x$: $2(x + 13) = 8x + 8$.'),
    ('Solve for $x$: $7(x + 4) = 6x - 15$.'),
    ('Solve for $x$: $3(x - 8) = 2x + 9$.'),
    ('Solve for $x$: $6(x + 3) = 2x + 9$.')
) as p(txt)
where s.name = 'Linear Equations and Inequalities Review' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve the system: $6x - 4y + z = 2$, $4x + y = -2$, and $-4x + 3z = 0$.'),
    ('Solve the system: $4x + y - 5z = 1$, $-x - y = -1$, and $4x - 5z = 0$.'),
    ('Solve the system: $-4x - y + 5z = 1$, $-2x + 4y = 6$, and $2x - 6z = 0$.'),
    ('Solve the system: $x - 5y - z = -2$, $-x - 5y = 6$, and $2x - 6z = 0$.'),
    ('Solve the system: $4x + 2y + z = -6$, $-3x + 2y = -1$, and $3x + 6z = 0$.'),
    ('Solve the system: $x + 4y + z = 6$, $-6x - 3y = -2$, and $2x - 4z = 0$.'),
    ('Solve the system: $-2x + y + 5z = 1$, $-5x - 6y = 4$, and $3x + 6z = 0$.'),
    ('Solve the system: $-3x + 5y - 4z = -2$, $2x - 6y = 2$, and $-5x - 3z = 0$.'),
    ('Solve the system: $-5x + y - 5z = 4$, $-4x + y = 5$, and $-2x + 2z = 0$.'),
    ('Solve the system: $5x - 2y + z = 1$, $-3x + y = 2$, and $-4x - 3z = 0$.'),
    ('Solve the system: $3x + 2y + 5z = -4$, $-5x - 2y = 6$, and $6x - z = 0$.'),
    ('Solve the system: $6x + 2y - 2z = -6$, $-2x + 5y = -2$, and $3x + 3z = 0$.'),
    ('Solve the system: $4x + y - 4z = 1$, $2x + y = -1$, and $-x + 2z = 0$.'),
    ('Solve the system: $6x + 2y + z = -1$, $-3x + 5y = -3$, and $3x - 3z = 0$.'),
    ('Solve the system: $6x - 6y - z = 5$, $x + 5y = 6$, and $4x + 6z = 0$.')
) as p(txt)
where s.name = 'Systems of Linear Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $6x^2 - 11x + 11 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $x^2 - 11x + 12 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $5x^2 - 5x - 14 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $4x^2 - 12x + 13 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $4x^2 - 15x - 11 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $4x^2 + 12x - 11 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $x^2 + 10x - 4 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $3x^2 + 4x + 5 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $6x^2 - 13x + 1 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $6x^2 + 12x + 14 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $4x^2 + 15x + 20 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $6x^2 + 13x + 11 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $5x^2 - 14x + 19 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $x^2 - 8x + 20 = 0$ using the quadratic formula, and state whether the roots are real or complex.'),
    ('Solve $6x^2 + 14x - 2 = 0$ using the quadratic formula, and state whether the roots are real or complex.')
) as p(txt)
where s.name = 'Quadratic Functions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given $P(x) = x^3 - 2x^2 - 2x + 7$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - x^2 - 2x + 8$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 2x^2 - 5x + 1$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - x^2 - 6x + 1$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 3x^2 - 6x + 6$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 4x^2 - 3x + 4$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 5x^2 - 7x + 10$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 6x^2 - 3x + 3$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 2x^2 - 2x + 10$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 4x^2 - 4x + 8$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 5x^2 - 3x + 4$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 4x^2 - 5x + 8$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 3x^2 - x + 8$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - 3x^2 - 9x + 3$, use the Rational Root Theorem to list the possible rational roots.'),
    ('Given $P(x) = x^3 - x^2 - 8x + 6$, use the Rational Root Theorem to list the possible rational roots.')
) as p(txt)
where s.name = 'Polynomial Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\frac{x^2 - 36}{x - 6}$.'),
    ('Simplify $\frac{x^2 - 64}{x - 8}$.'),
    ('Simplify $\frac{x^2 - 36}{x - 6}$.'),
    ('Simplify $\frac{x^2 - 81}{x - 9}$.'),
    ('Simplify $\frac{x^2 - 36}{x - 6}$.'),
    ('Simplify $\frac{x^2 - 25}{x - 5}$.'),
    ('Simplify $\frac{x^2 - 64}{x - 8}$.'),
    ('Simplify $\frac{x^2 - 81}{x - 9}$.'),
    ('Simplify $\frac{x^2 - 9}{x - 3}$.'),
    ('Simplify $\frac{x^2 - 25}{x - 5}$.'),
    ('Simplify $\frac{x^2 - 64}{x - 8}$.'),
    ('Simplify $\frac{x^2 - 49}{x - 7}$.'),
    ('Simplify $\frac{x^2 - 36}{x - 6}$.'),
    ('Simplify $\frac{x^2 - 36}{x - 6}$.'),
    ('Simplify $\frac{x^2 - 4}{x - 2}$.')
) as p(txt)
where s.name = 'Rational Expressions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $\sqrt{2x + 7} = x - 3$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 1} = x - 5$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 1} = x - 5$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 8} = x - 3$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 4} = x - 5$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 6} = x - 2$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 4} = x - 5$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 5} = x - 6$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 3} = x - 6$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 2} = x - 6$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 1} = x - 3$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 8} = x - 1$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 10} = x - 3$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 3} = x - 1$, and check for extraneous solutions.'),
    ('Solve $\sqrt{2x + 5} = x - 3$, and check for extraneous solutions.')
) as p(txt)
where s.name = 'Radical Expressions and Equations' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve for $x$: $5^x = 25$.'),
    ('Solve for $x$: $3^x = 9$.'),
    ('Solve for $x$: $4^x = 64$.'),
    ('Solve for $x$: $3^x = 27$.'),
    ('Solve for $x$: $5^x = 125$.'),
    ('Solve for $x$: $4^x = 4$.'),
    ('Solve for $x$: $5^x = 5$.'),
    ('Solve for $x$: $3^x = 9$.'),
    ('Solve for $x$: $5^x = 125$.'),
    ('Solve for $x$: $2^x = 16$.'),
    ('Solve for $x$: $2^x = 8$.'),
    ('Solve for $x$: $2^x = 16$.'),
    ('Solve for $x$: $4^x = 64$.'),
    ('Solve for $x$: $5^x = 125$.'),
    ('Solve for $x$: $2^x = 4$.')
) as p(txt)
where s.name = 'Exponential Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $\log_{5}(x) = 1$.'),
    ('Solve $\log_{4}(x) = 2$.'),
    ('Solve $\log_{2}(x) = 4$.'),
    ('Solve $\log_{4}(x) = 4$.'),
    ('Solve $\log_{2}(x) = 2$.'),
    ('Solve $\log_{2}(x) = 1$.'),
    ('Solve $\log_{4}(x) = 4$.'),
    ('Solve $\log_{2}(x) = 1$.'),
    ('Solve $\log_{3}(x) = 2$.'),
    ('Solve $\log_{5}(x) = 4$.'),
    ('Solve $\log_{4}(x) = 4$.'),
    ('Solve $\log_{3}(x) = 4$.'),
    ('Solve $\log_{2}(x) = 4$.'),
    ('Solve $\log_{5}(x) = 3$.'),
    ('Solve $\log_{2}(x) = 3$.')
) as p(txt)
where s.name = 'Logarithmic Functions' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the sum of the first 11 terms of the arithmetic sequence with first term $a_1 = -4$ and common difference $d = 8$.'),
    ('Find the sum of the first 5 terms of the arithmetic sequence with first term $a_1 = -3$ and common difference $d = 6$.'),
    ('Find the sum of the first 4 terms of the arithmetic sequence with first term $a_1 = 1$ and common difference $d = 6$.'),
    ('Find the sum of the first 7 terms of the arithmetic sequence with first term $a_1 = 2$ and common difference $d = 5$.'),
    ('Find the sum of the first 5 terms of the arithmetic sequence with first term $a_1 = -7$ and common difference $d = 8$.'),
    ('Find the sum of the first 4 terms of the arithmetic sequence with first term $a_1 = -4$ and common difference $d = 1$.'),
    ('Find the sum of the first 13 terms of the arithmetic sequence with first term $a_1 = -3$ and common difference $d = 3$.'),
    ('Find the sum of the first 12 terms of the arithmetic sequence with first term $a_1 = -4$ and common difference $d = 2$.'),
    ('Find the sum of the first 7 terms of the arithmetic sequence with first term $a_1 = -4$ and common difference $d = 4$.'),
    ('Find the sum of the first 8 terms of the arithmetic sequence with first term $a_1 = -6$ and common difference $d = 1$.'),
    ('Find the sum of the first 12 terms of the arithmetic sequence with first term $a_1 = -6$ and common difference $d = 3$.'),
    ('Find the sum of the first 5 terms of the arithmetic sequence with first term $a_1 = -2$ and common difference $d = 3$.'),
    ('Find the sum of the first 4 terms of the arithmetic sequence with first term $a_1 = -10$ and common difference $d = 3$.'),
    ('Find the sum of the first 13 terms of the arithmetic sequence with first term $a_1 = 1$ and common difference $d = 4$.'),
    ('Find the sum of the first 8 terms of the arithmetic sequence with first term $a_1 = -10$ and common difference $d = 3$.')
) as p(txt)
where s.name = 'Sequences and Series' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Identify the center and radius of the circle $x^2 + y^2 = 100$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 81$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 100$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 81$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 64$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 81$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 16$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 100$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 81$.'),
    ('Identify the center and the lengths of the semi-axes of the ellipse $\frac{x^2}{64} + \frac{y^2}{9} = 1$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 25$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 64$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 64$.'),
    ('Identify the center and radius of the circle $x^2 + y^2 = 16$.'),
    ('Identify the center and the lengths of the semi-axes of the ellipse $\frac{x^2}{81} + \frac{y^2}{9} = 1$.')
) as p(txt)
where s.name = 'Conic Sections' and s."courseId" = (select "courseId" from public.course where name = 'Algebra 2');

-- ================= Trigonometry =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Convert $45^\circ$ to radians.'),
    ('Convert $\frac{1\pi}{4}$ radians to degrees.'),
    ('Convert $\frac{1\pi}{3}$ radians to degrees.'),
    ('Convert $240^\circ$ to radians.'),
    ('Convert $\frac{3\pi}{2}$ radians to degrees.'),
    ('Convert $150^\circ$ to radians.'),
    ('Convert $\frac{3\pi}{2}$ radians to degrees.'),
    ('Convert $\frac{1\pi}{6}$ radians to degrees.'),
    ('Convert $\frac{4\pi}{3}$ radians to degrees.'),
    ('Convert $\frac{3\pi}{4}$ radians to degrees.'),
    ('Convert $240^\circ$ to radians.'),
    ('Convert $60^\circ$ to radians.'),
    ('Convert $\frac{1\pi}{2}$ radians to degrees.'),
    ('Convert $135^\circ$ to radians.'),
    ('Convert $\frac{1\pi}{4}$ radians to degrees.')
) as p(txt)
where s.name = 'Angles and Radian Measure' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A right triangle has legs of length 11 and 10. Find the measure of the angle opposite the leg of length 11.'),
    ('A right triangle has legs of length 16 and 20. Find the measure of the angle opposite the leg of length 16.'),
    ('A right triangle has legs of length 20 and 3. Find the measure of the angle opposite the leg of length 20.'),
    ('A right triangle has legs of length 11 and 3. Find the measure of the angle opposite the leg of length 11.'),
    ('A right triangle has legs of length 8 and 11. Find the measure of the angle opposite the leg of length 8.'),
    ('A right triangle has legs of length 12 and 13. Find the measure of the angle opposite the leg of length 12.'),
    ('A right triangle has legs of length 14 and 3. Find the measure of the angle opposite the leg of length 14.'),
    ('A right triangle has legs of length 8 and 7. Find the measure of the angle opposite the leg of length 8.'),
    ('A right triangle has legs of length 15 and 5. Find the measure of the angle opposite the leg of length 15.'),
    ('A right triangle has legs of length 7 and 3. Find the measure of the angle opposite the leg of length 7.'),
    ('A right triangle has legs of length 5 and 19. Find the measure of the angle opposite the leg of length 5.'),
    ('A right triangle has legs of length 9 and 15. Find the measure of the angle opposite the leg of length 9.'),
    ('A right triangle has legs of length 16 and 17. Find the measure of the angle opposite the leg of length 16.'),
    ('A right triangle has legs of length 13 and 8. Find the measure of the angle opposite the leg of length 13.'),
    ('A right triangle has legs of length 14 and 12. Find the measure of the angle opposite the leg of length 14.')
) as p(txt)
where s.name = 'Right Triangle Trigonometry' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the exact value of $\tan(3\pi/4)$ using the unit circle.'),
    ('Find the exact value of $\tan(5\pi/4)$ using the unit circle.'),
    ('Find the exact value of $\sin(\pi/6)$ using the unit circle.'),
    ('Find the exact value of $\sin(\pi/3)$ using the unit circle.'),
    ('Find the exact value of $\tan(\pi/6)$ using the unit circle.'),
    ('Find the exact value of $\tan(\pi/4)$ using the unit circle.'),
    ('Find the exact value of $\cos(\pi)$ using the unit circle.'),
    ('Find the exact value of $\tan(5\pi/6)$ using the unit circle.'),
    ('Find the exact value of $\cos(5\pi/4)$ using the unit circle.'),
    ('Find the exact value of $\cos(5\pi/6)$ using the unit circle.'),
    ('Find the exact value of $\cos(\pi/2)$ using the unit circle.'),
    ('Find the exact value of $\tan(\pi/4)$ using the unit circle.'),
    ('Find the exact value of $\cos(5\pi/6)$ using the unit circle.'),
    ('Find the exact value of $\sin(2\pi/3)$ using the unit circle.'),
    ('Find the exact value of $\tan(5\pi/4)$ using the unit circle.')
) as p(txt)
where s.name = 'The Unit Circle' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Describe the amplitude, period, and phase shift of $y = 4\sin(3x - 1)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 4\sin(x - 1)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 3\sin(2x - 1)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 3\sin(3x - 2)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 1\sin(x - 3)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 4\sin(2x - 1)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 4\sin(2x - 2)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 1\sin(4x - 3)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 1\sin(4x - 2)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 5\sin(4x - 3)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 4\sin(3x - 3)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 1\sin(3x - 1)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 5\sin(4x - 2)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 1\sin(4x - 1)$.'),
    ('Describe the amplitude, period, and phase shift of $y = 4\sin(4x - 3)$.')
) as p(txt)
where s.name = 'Graphs of Trigonometric Functions' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Simplify $\sin(x)\cos(x) \cdot 2$ using a double-angle identity.'),
    ('Simplify $\sin(x)\cos(x) \cdot 2$ using a double-angle identity.'),
    ('Prove the identity $1 + \tan^2(x) = \sec^2(x)$.'),
    ('Simplify $\sin(x)\cos(x) \cdot 2$ using a double-angle identity.'),
    ('Prove the identity $1 + \tan^2(x) = \sec^2(x)$.'),
    ('Simplify $\frac{{\sin(x)}}{{\cos(x)}} \cdot \cos(x)$ using a trigonometric identity.'),
    ('Rewrite $\sin(x + y)$ using the angle sum identity.'),
    ('Simplify $\frac{{\sin(x)}}{{\cos(x)}} \cdot \cos(x)$ using a trigonometric identity.'),
    ('Rewrite $\sin(x + y)$ using the angle sum identity.'),
    ('Rewrite $\sin(x + y)$ using the angle sum identity.'),
    ('Prove the identity $1 + \tan^2(x) = \sec^2(x)$.'),
    ('Simplify $\sin(x)\cos(x) \cdot 2$ using a double-angle identity.'),
    ('Simplify $\sin(x)\cos(x) \cdot 2$ using a double-angle identity.'),
    ('Prove the identity $1 + \tan^2(x) = \sec^2(x)$.'),
    ('Prove the identity $1 + \tan^2(x) = \sec^2(x)$.')
) as p(txt)
where s.name = 'Trigonometric Identities' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve $1\sin(x) = -2$ for $0 \le x < 2\pi$.'),
    ('Solve $1\sin(x) = -3$ for $0 \le x < 2\pi$.'),
    ('Solve $1\cos(x) = 2$ for $0 \le x < 2\pi$.'),
    ('Solve $3\cos(x) = 3$ for $0 \le x < 2\pi$.'),
    ('Solve $1\cos(x) = 1$ for $0 \le x < 2\pi$.'),
    ('Solve $2\sin(x) = 2$ for $0 \le x < 2\pi$.'),
    ('Solve $2\cos(x) = -2$ for $0 \le x < 2\pi$.'),
    ('Solve $2\cos(x) = -1$ for $0 \le x < 2\pi$.'),
    ('Solve $2\sin(x) = -3$ for $0 \le x < 2\pi$.'),
    ('Solve $3\sin(x) = 2$ for $0 \le x < 2\pi$.'),
    ('Solve $2\cos(x) = -2$ for $0 \le x < 2\pi$.'),
    ('Solve $3\cos(x) = -1$ for $0 \le x < 2\pi$.'),
    ('Solve $1\sin(x) = 3$ for $0 \le x < 2\pi$.'),
    ('Solve $3\sin(x) = -1$ for $0 \le x < 2\pi$.'),
    ('Solve $3\sin(x) = 2$ for $0 \le x < 2\pi$.')
) as p(txt)
where s.name = 'Solving Trigonometric Equations' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('In triangle $ABC$, $a = 14$, $b = 14$, and $\angle C = 137^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $a = 15$, $b = 16$, and $\angle C = 119^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $a = 4$, $b = 13$, and $\angle C = 28^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $a = 6$, $b = 20$, and $\angle C = 106^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $\angle A = 62^\circ$, $a = 12$, and $b = 11$. Use the Law of Sines to find $\angle B$.'),
    ('In triangle $ABC$, $a = 5$, $b = 7$, and $\angle C = 137^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $\angle A = 59^\circ$, $a = 12$, and $b = 15$. Use the Law of Sines to find $\angle B$.'),
    ('In triangle $ABC$, $a = 20$, $b = 15$, and $\angle C = 102^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $a = 7$, $b = 19$, and $\angle C = 31^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $a = 19$, $b = 14$, and $\angle C = 22^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $a = 12$, $b = 8$, and $\angle C = 47^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $\angle A = 39^\circ$, $a = 18$, and $b = 9$. Use the Law of Sines to find $\angle B$.'),
    ('In triangle $ABC$, $\angle A = 84^\circ$, $a = 5$, and $b = 12$. Use the Law of Sines to find $\angle B$.'),
    ('In triangle $ABC$, $a = 20$, $b = 19$, and $\angle C = 24^\circ$. Use the Law of Cosines to find side $c$.'),
    ('In triangle $ABC$, $\angle A = 43^\circ$, $a = 7$, and $b = 15$. Use the Law of Sines to find $\angle B$.')
) as p(txt)
where s.name = 'Law of Sines and Law of Cosines' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\arctan(-1)$.'),
    ('Evaluate $\arctan(\sqrt{{3}})$.'),
    ('Evaluate $\arcsin(\sqrt{{3}}/2)$.'),
    ('Evaluate $\arccos(1/2)$.'),
    ('Evaluate $\arccos(-1/2)$.'),
    ('Evaluate $\arctan(\sqrt{{3}})$.'),
    ('Evaluate $\arcsin(1/2)$.'),
    ('Evaluate $\arccos(\sqrt{{3}})$.'),
    ('Evaluate $\arcsin(\sqrt{{2}}/2)$.'),
    ('Evaluate $\arctan(\sqrt{{3}})$.'),
    ('Evaluate $\arccos(-1/2)$.'),
    ('Evaluate $\arccos(\sqrt{{3}}/2)$.'),
    ('Evaluate $\arcsin(1/2)$.'),
    ('Evaluate $\arctan(-1)$.'),
    ('Evaluate $\arccos(0)$.')
) as p(txt)
where s.name = 'Inverse Trigonometric Functions' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Convert the point $(8, \pi)$ from polar to rectangular coordinates.'),
    ('Convert the point $(6, 2\pi/3)$ from polar to rectangular coordinates.'),
    ('Convert the point $(2, 3\pi/4)$ from polar to rectangular coordinates.'),
    ('Convert the point $(9, \pi)$ from polar to rectangular coordinates.'),
    ('Convert the point $(2, \pi/3)$ from polar to rectangular coordinates.'),
    ('Convert the point $(2, \pi)$ from polar to rectangular coordinates.'),
    ('Convert the point $(3, \pi/3)$ from polar to rectangular coordinates.'),
    ('Convert the point $(8, 2\pi/3)$ from polar to rectangular coordinates.'),
    ('Convert the point $(3, \pi)$ from polar to rectangular coordinates.'),
    ('Convert the point $(7, \pi/6)$ from polar to rectangular coordinates.'),
    ('Convert the point $(4, \pi)$ from polar to rectangular coordinates.'),
    ('Convert the point $(8, \pi/3)$ from polar to rectangular coordinates.'),
    ('Convert the point $(1, \pi/2)$ from polar to rectangular coordinates.'),
    ('Convert the point $(1, \pi/2)$ from polar to rectangular coordinates.'),
    ('Convert the point $(9, \pi/3)$ from polar to rectangular coordinates.')
) as p(txt)
where s.name = 'Polar Coordinates' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the magnitude and direction angle of the vector $\langle -3, 2 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -8, 1 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -3, -10 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -7, 10 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -6, -6 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -9, -1 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle 5, -6 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle 5, 4 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle 9, -10 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -8, -10 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -2, -4 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -6, 7 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle 9, 6 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle 3, -7 \rangle$.'),
    ('Find the magnitude and direction angle of the vector $\langle -1, -3 \rangle$.')
) as p(txt)
where s.name = 'Vectors' and s."courseId" = (select "courseId" from public.course where name = 'Trigonometry');

-- ================= Geometry =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the midpoint of the segment with endpoints $(-1, -7)$ and $(-9, -3)$.'),
    ('Find the midpoint of the segment with endpoints $(3, 10)$ and $(9, 4)$.'),
    ('Find the midpoint of the segment with endpoints $(-8, -7)$ and $(5, 9)$.'),
    ('Find the midpoint of the segment with endpoints $(7, -10)$ and $(10, 6)$.'),
    ('Find the midpoint of the segment with endpoints $(8, -3)$ and $(-6, -1)$.'),
    ('Find the midpoint of the segment with endpoints $(3, -10)$ and $(9, 1)$.'),
    ('Find the midpoint of the segment with endpoints $(-3, 8)$ and $(3, -5)$.'),
    ('Find the midpoint of the segment with endpoints $(-8, 6)$ and $(1, -8)$.'),
    ('Find the midpoint of the segment with endpoints $(6, 7)$ and $(6, 6)$.'),
    ('Find the midpoint of the segment with endpoints $(7, -10)$ and $(2, 5)$.'),
    ('Find the midpoint of the segment with endpoints $(-9, 10)$ and $(2, 1)$.'),
    ('Find the midpoint of the segment with endpoints $(-2, -10)$ and $(1, -8)$.'),
    ('Find the midpoint of the segment with endpoints $(1, -3)$ and $(10, -7)$.'),
    ('Find the midpoint of the segment with endpoints $(8, -6)$ and $(-9, 1)$.'),
    ('Find the midpoint of the segment with endpoints $(7, 10)$ and $(-5, 4)$.')
) as p(txt)
where s.name = 'Points, Lines, and Planes' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Two angles are complementary. One angle measures 35 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 16 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 13 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 9 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 34 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 7 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 23 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 17 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 7 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 17 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 7 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 25 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 24 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 37 degrees more than twice the other. Find both angle measures.'),
    ('Two angles are complementary. One angle measures 30 degrees more than twice the other. Find both angle measures.')
) as p(txt)
where s.name = 'Angles and Angle Relationships' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Triangle $ABC$ has $AB = 11$, $BC = 10$, and $\angle B = 62^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 3$, $BC = 15$, and $\angle B = 112^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 6$, $BC = 7$, and $\angle B = 75^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 15$, $BC = 3$, and $\angle B = 113^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 8$, $BC = 7$, and $\angle B = 45^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 15$, $BC = 8$, and $\angle B = 85^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 9$, $BC = 14$, and $\angle B = 86^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 9$, $BC = 8$, and $\angle B = 53^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 10$, $BC = 14$, and $\angle B = 93^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 8$, $BC = 15$, and $\angle B = 96^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 7$, $BC = 15$, and $\angle B = 40^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 14$, $BC = 9$, and $\angle B = 40^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 9$, $BC = 12$, and $\angle B = 53^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 11$, $BC = 7$, and $\angle B = 71^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?'),
    ('Triangle $ABC$ has $AB = 4$, $BC = 4$, and $\angle B = 71^\circ$. Which triangle congruence postulate would prove a second triangle with the same three measurements congruent to it?')
) as p(txt)
where s.name = 'Triangle Congruence' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 0.5. If $AB = 13$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 7$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 12$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 5$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 8$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 0.5. If $AB = 3$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 12$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 2. If $AB = 7$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 4$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 2.5. If $AB = 8$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 3. If $AB = 15$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 3. If $AB = 3$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 1.5. If $AB = 12$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 3. If $AB = 3$, find $DE$.'),
    ('Triangle $ABC$ is similar to triangle $DEF$ with a scale factor of 3. If $AB = 4$, find $DE$.')
) as p(txt)
where s.name = 'Triangle Similarity' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the sum of the interior angles of a polygon with 10 sides.'),
    ('Find the sum of the interior angles of a polygon with 10 sides.'),
    ('Find the sum of the interior angles of a polygon with 11 sides.'),
    ('Find the sum of the interior angles of a polygon with 5 sides.'),
    ('Find the sum of the interior angles of a polygon with 7 sides.'),
    ('Find the sum of the interior angles of a polygon with 12 sides.'),
    ('Find the sum of the interior angles of a polygon with 10 sides.'),
    ('Find the sum of the interior angles of a polygon with 10 sides.'),
    ('Find the sum of the interior angles of a polygon with 12 sides.'),
    ('Find the sum of the interior angles of a polygon with 6 sides.'),
    ('Find the sum of the interior angles of a polygon with 7 sides.'),
    ('Find the sum of the interior angles of a polygon with 10 sides.'),
    ('Find the sum of the interior angles of a polygon with 11 sides.'),
    ('Find the sum of the interior angles of a polygon with 10 sides.'),
    ('Find the sum of the interior angles of a polygon with 9 sides.')
) as p(txt)
where s.name = 'Polygons and Quadrilaterals' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A circle has radius 9. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 5. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 2. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 7. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 17. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 18. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 14. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 19. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 5. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 10. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 10. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 16. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 8. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 11. Find its circumference and area in terms of $\pi$.'),
    ('A circle has radius 17. Find its circumference and area in terms of $\pi$.')
) as p(txt)
where s.name = 'Circles' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the area and perimeter of a rectangle with length 9 and width 6.'),
    ('Find the area and perimeter of a rectangle with length 7 and width 5.'),
    ('Find the area and perimeter of a rectangle with length 17 and width 8.'),
    ('Find the area and perimeter of a rectangle with length 25 and width 17.'),
    ('Find the area and perimeter of a rectangle with length 5 and width 24.'),
    ('Find the area and perimeter of a rectangle with length 13 and width 24.'),
    ('Find the area and perimeter of a rectangle with length 14 and width 25.'),
    ('Find the area and perimeter of a rectangle with length 5 and width 20.'),
    ('Find the area and perimeter of a rectangle with length 20 and width 12.'),
    ('Find the area and perimeter of a rectangle with length 12 and width 8.'),
    ('Find the area and perimeter of a rectangle with length 25 and width 25.'),
    ('Find the area and perimeter of a rectangle with length 25 and width 23.'),
    ('Find the area and perimeter of a rectangle with length 8 and width 14.'),
    ('Find the area and perimeter of a rectangle with length 19 and width 10.'),
    ('Find the area and perimeter of a rectangle with length 6 and width 9.')
) as p(txt)
where s.name = 'Area and Perimeter' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the volume and surface area of a rectangular prism with dimensions 4 by 5 by 9.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 2 by 7 by 10.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 11 by 7 by 9.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 10 by 4 by 11.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 3 by 3 by 6.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 8 by 9 by 10.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 8 by 8 by 11.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 3 by 4 by 7.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 12 by 3 by 9.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 9 by 12 by 10.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 7 by 4 by 10.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 12 by 11 by 4.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 4 by 8 by 10.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 2 by 3 by 10.'),
    ('Find the volume and surface area of a rectangular prism with dimensions 4 by 6 by 4.')
) as p(txt)
where s.name = 'Surface Area and Volume' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the distance between the points $(-5, -3)$ and $(1, 6)$.'),
    ('Find the distance between the points $(-1, -8)$ and $(-2, -4)$.'),
    ('Find the distance between the points $(10, 7)$ and $(-2, -6)$.'),
    ('Find the distance between the points $(10, -1)$ and $(9, 7)$.'),
    ('Find the distance between the points $(-8, 6)$ and $(10, -5)$.'),
    ('Find the distance between the points $(8, 8)$ and $(-6, -5)$.'),
    ('Find the distance between the points $(9, 9)$ and $(8, -9)$.'),
    ('Find the distance between the points $(-10, -8)$ and $(-9, 10)$.'),
    ('Find the distance between the points $(8, -2)$ and $(10, -4)$.'),
    ('Find the distance between the points $(8, 3)$ and $(9, 10)$.'),
    ('Find the distance between the points $(-10, 5)$ and $(10, 7)$.'),
    ('Find the distance between the points $(-1, 10)$ and $(-1, 5)$.'),
    ('Find the distance between the points $(-3, 2)$ and $(-1, 4)$.'),
    ('Find the distance between the points $(-8, -9)$ and $(-5, 4)$.'),
    ('Find the distance between the points $(3, 5)$ and $(4, -4)$.')
) as p(txt)
where s.name = 'Coordinate Geometry' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Point $A(2, -4)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(2, 3)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(-4, 3)$ is reflected over the line $y = x$. Find the coordinates of its image.'),
    ('Point $A(-5, 2)$ is reflected over the $x$-axis. Find the coordinates of its image.'),
    ('Point $A(6, -5)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(6, -1)$ is reflected over the $x$-axis. Find the coordinates of its image.'),
    ('Point $A(-5, -7)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(4, 5)$ is reflected over the $x$-axis. Find the coordinates of its image.'),
    ('Point $A(-3, 2)$ is reflected over the line $y = x$. Find the coordinates of its image.'),
    ('Point $A(2, -2)$ is reflected over the $x$-axis. Find the coordinates of its image.'),
    ('Point $A(7, 8)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(7, 1)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(-8, -6)$ is reflected over the $y$-axis. Find the coordinates of its image.'),
    ('Point $A(8, 6)$ is reflected over the $x$-axis. Find the coordinates of its image.'),
    ('Point $A(-2, 3)$ is reflected over the $x$-axis. Find the coordinates of its image.')
) as p(txt)
where s.name = 'Transformations' and s."courseId" = (select "courseId" from public.course where name = 'Geometry');

-- ================= Calculus 1 =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\lim_{x \to -5} (x^2 + 5x)$.'),
    ('Evaluate $\lim_{x \to 2} (x^2 + 8x)$.'),
    ('Evaluate $\lim_{x \to -1} (x^2 + 9x)$.'),
    ('Evaluate $\lim_{x \to -5} (x^2 + 2x)$.'),
    ('Evaluate $\lim_{x \to 1} (x^2 + 3x)$.'),
    ('Evaluate $\lim_{x \to -1} (x^2 + 6x)$.'),
    ('Evaluate $\lim_{x \to 1} (x^2 + 6x)$.'),
    ('Evaluate $\lim_{x \to -5} (x^2 + 7x)$.'),
    ('Evaluate $\lim_{x \to -5} (x^2 + 9x)$.'),
    ('Evaluate $\lim_{x \to -2} (x^2 + 6x)$.'),
    ('Evaluate $\lim_{x \to 3} (x^2 + 5x)$.'),
    ('Evaluate $\lim_{x \to -4} (x^2 + 7x)$.'),
    ('Evaluate $\lim_{x \to 3} (x^2 + 8x)$.'),
    ('Evaluate $\lim_{x \to 3} (x^2 + 5x)$.'),
    ('Evaluate $\lim_{x \to 4} (x^2 + 2x)$.')
) as p(txt)
where s.name = 'Limits and Continuity' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 3x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 2x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 7x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 6x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 6x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 9x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 6x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 3x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 4x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 9x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 7x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + 9x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + x$.'),
    ('Use the limit definition of the derivative to find $f''(x)$ for $f(x) = x^2 + x$.')
) as p(txt)
where s.name = 'The Derivative Definition' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the derivative of $f(x) = 3x^{4} + 8x$.'),
    ('Find the derivative of $f(x) = 9x^{5} + 3x$.'),
    ('Find the derivative of $f(x) = 9x^{3} + 6x$.'),
    ('Find the derivative of $f(x) = 6x^{3} + 7x$.'),
    ('Find the derivative of $f(x) = 5x^{4} + 9x$.'),
    ('Find the derivative of $f(x) = 9x^{5} + 5x$.'),
    ('Find the derivative of $f(x) = 8x^{2} + 6x$.'),
    ('Find the derivative of $f(x) = 6x^{2} + 7x$.'),
    ('Find the derivative of $f(x) = 5x^{2} + 8x$.'),
    ('Find the derivative of $f(x) = 5x^{3} + x$.'),
    ('Find the derivative of $f(x) = 8x^{3} + 9x$.'),
    ('Find the derivative of $f(x) = 7x^{3} + 4x$.'),
    ('Find the derivative of $f(x) = x^{2} + 4x$.'),
    ('Find the derivative of $f(x) = x^{5} + 6x$.'),
    ('Find the derivative of $f(x) = 7x^{3} + 7x$.')
) as p(txt)
where s.name = 'Differentiation Rules' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = -2$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 1$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 3$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 4$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 2$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = -5$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = -3$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 3$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = -2$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 3$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 5$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 2$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 3$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = 1$.'),
    ('Find the equation of the tangent line to $f(x) = x^2$ at $x = -3$.')
) as p(txt)
where s.name = 'Applications of Derivatives' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A ladder 20 feet long leans against a wall. The bottom slides away from the wall at 5 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 21 feet long leans against a wall. The bottom slides away from the wall at 6 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 18 feet long leans against a wall. The bottom slides away from the wall at 7 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 25 feet long leans against a wall. The bottom slides away from the wall at 6 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 17 feet long leans against a wall. The bottom slides away from the wall at 3 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 19 feet long leans against a wall. The bottom slides away from the wall at 4 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 19 feet long leans against a wall. The bottom slides away from the wall at 3 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 19 feet long leans against a wall. The bottom slides away from the wall at 8 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 16 feet long leans against a wall. The bottom slides away from the wall at 7 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 25 feet long leans against a wall. The bottom slides away from the wall at 7 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 25 feet long leans against a wall. The bottom slides away from the wall at 4 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 18 feet long leans against a wall. The bottom slides away from the wall at 4 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 13 feet long leans against a wall. The bottom slides away from the wall at 4 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 22 feet long leans against a wall. The bottom slides away from the wall at 6 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?'),
    ('A ladder 21 feet long leans against a wall. The bottom slides away from the wall at 5 feet per second. How fast is the top of the ladder sliding down when the bottom is 6 feet from the wall?')
) as p(txt)
where s.name = 'Related Rates' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A rectangular field is to be enclosed with 77 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 114 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 50 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 113 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 60 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 128 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 153 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 105 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 162 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 94 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 91 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 177 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 109 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 183 feet of fencing. Find the dimensions that maximize the enclosed area.'),
    ('A rectangular field is to be enclosed with 109 feet of fencing. Find the dimensions that maximize the enclosed area.')
) as p(txt)
where s.name = 'Optimization Problems' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-4, 1]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-1, 6]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-1, 2]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-4, 1]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-1, 2]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-4, 1]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-5, 4]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-3, 6]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-2, 1]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-4, 1]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-1, 2]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-2, 6]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-2, 4]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-4, 3]$, and find the value of $c$ that satisfies it.'),
    ('Verify that the Mean Value Theorem applies to $f(x) = x^2$ on $[-3, 3]$, and find the value of $c$ that satisfies it.')
) as p(txt)
where s.name = 'The Mean Value Theorem' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find $\int (x^{1} + 4)\,dx$.'),
    ('Find $\int (9x^{1} + 3)\,dx$.'),
    ('Find $\int (7x^{2} + 1)\,dx$.'),
    ('Find $\int (7x^{4} + 3)\,dx$.'),
    ('Find $\int (5x^{1} + 1)\,dx$.'),
    ('Find $\int (5x^{5} + 2)\,dx$.'),
    ('Find $\int (6x^{3} + 8)\,dx$.'),
    ('Find $\int (9x^{5} + 8)\,dx$.'),
    ('Find $\int (3x^{5} + 8)\,dx$.'),
    ('Find $\int (5x^{2} + 2)\,dx$.'),
    ('Find $\int (6x^{2} + 8)\,dx$.'),
    ('Find $\int (5x^{2} + 1)\,dx$.'),
    ('Find $\int (6x^{3} + 4)\,dx$.'),
    ('Find $\int (3x^{5} + 7)\,dx$.'),
    ('Find $\int (7x^{5} + 6)\,dx$.')
) as p(txt)
where s.name = 'Antiderivatives and Indefinite Integrals' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Evaluate $\int_{-4}^{1} x^2\,dx$.'),
    ('Evaluate $\int_{-4}^{5} x^2\,dx$.'),
    ('Evaluate $\int_{-3}^{-2} x^2\,dx$.'),
    ('Evaluate $\int_{-2}^{2} x^2\,dx$.'),
    ('Evaluate $\int_{-5}^{-1} x^2\,dx$.'),
    ('Evaluate $\int_{-2}^{1} x^2\,dx$.'),
    ('Evaluate $\int_{-1}^{2} x^2\,dx$.'),
    ('Evaluate $\int_{-1}^{4} x^2\,dx$.'),
    ('Evaluate $\int_{-5}^{4} x^2\,dx$.'),
    ('Evaluate $\int_{-1}^{5} x^2\,dx$.'),
    ('Evaluate $\int_{-5}^{-2} x^2\,dx$.'),
    ('Evaluate $\int_{-4}^{5} x^2\,dx$.'),
    ('Evaluate $\int_{-1}^{2} x^2\,dx$.'),
    ('Evaluate $\int_{-3}^{1} x^2\,dx$.'),
    ('Evaluate $\int_{3}^{5} x^2\,dx$.')
) as p(txt)
where s.name = 'The Definite Integral' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('If $F(x) = \int_{5}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{2}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{5}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{5}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{2}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{2}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{4}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{1}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{1}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{1}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{3}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{1}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{3}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{5}^{x} (t^2 + 1)\,dt$, find $F''(x)$.'),
    ('If $F(x) = \int_{4}^{x} (t^2 + 1)\,dt$, find $F''(x)$.')
) as p(txt)
where s.name = 'The Fundamental Theorem of Calculus' and s."courseId" = (select "courseId" from public.course where name = 'Calculus 1');

-- ================= Linear Algebra =================
insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Solve the system $-x + 5y = 2$ and $x + 6y = 2$ using matrices.'),
    ('Solve the system $6x + 4y = -3$ and $6x - 3y = 4$ using matrices.'),
    ('Solve the system $6x + 3y = 6$ and $-5x + 2y = 1$ using matrices.'),
    ('Solve the system $2x + 5y = -1$ and $-5x + 3y = -5$ using matrices.'),
    ('Solve the system $-6x + 2y = 2$ and $-3x + 3y = 2$ using matrices.'),
    ('Solve the system $-4x - 4y = -1$ and $2x + y = -5$ using matrices.'),
    ('Solve the system $4x - 3y = 5$ and $3x + y = -5$ using matrices.'),
    ('Solve the system $2x + y = 6$ and $-6x + y = -4$ using matrices.'),
    ('Solve the system $2x + y = 3$ and $-6x + 2y = 1$ using matrices.'),
    ('Solve the system $4x + 6y = -2$ and $5x - 6y = -2$ using matrices.'),
    ('Solve the system $-6x + 5y = -3$ and $3x - 5y = -6$ using matrices.'),
    ('Solve the system $-x + 5y = -5$ and $2x - 6y = -5$ using matrices.'),
    ('Solve the system $x - 6y = -2$ and $-4x + 6y = -4$ using matrices.'),
    ('Solve the system $6x + 4y = 5$ and $4x - y = 1$ using matrices.'),
    ('Solve the system $-5x + 4y = 4$ and $2x - 4y = 4$ using matrices.')
) as p(txt)
where s.name = 'Systems of Linear Equations and Matrices' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given $A = \begin{pmatrix} 2 & -6 \\ -4 & 8 \end{pmatrix}$ and $B = \begin{pmatrix} 3 & 7 \\ -5 & -2 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} -9 & 5 \\ 8 & 4 \end{pmatrix}$ and $B = \begin{pmatrix} 8 & 3 \\ -2 & -2 \end{pmatrix}$, find $AB$.'),
    ('Given $A = \begin{pmatrix} 2 & -5 \\ -1 & -3 \end{pmatrix}$ and $B = \begin{pmatrix} -6 & -8 \\ 4 & -9 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} -3 & -7 \\ -6 & -8 \end{pmatrix}$ and $B = \begin{pmatrix} 5 & -8 \\ -2 & -8 \end{pmatrix}$, find $AB$.'),
    ('Given $A = \begin{pmatrix} 5 & -2 \\ 8 & -3 \end{pmatrix}$ and $B = \begin{pmatrix} -8 & -5 \\ 7 & -2 \end{pmatrix}$, find $AB$.'),
    ('Given $A = \begin{pmatrix} 9 & 1 \\ -2 & -5 \end{pmatrix}$ and $B = \begin{pmatrix} 7 & -2 \\ 4 & -1 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} 8 & 9 \\ -4 & 4 \end{pmatrix}$ and $B = \begin{pmatrix} 8 & 6 \\ -8 & 2 \end{pmatrix}$, find $AB$.'),
    ('Given $A = \begin{pmatrix} 7 & 1 \\ 4 & 4 \end{pmatrix}$ and $B = \begin{pmatrix} -5 & 3 \\ -4 & 8 \end{pmatrix}$, find $AB$.'),
    ('Given $A = \begin{pmatrix} -2 & -2 \\ -5 & 5 \end{pmatrix}$ and $B = \begin{pmatrix} -8 & 8 \\ 4 & 4 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} 3 & -2 \\ -1 & -3 \end{pmatrix}$ and $B = \begin{pmatrix} 1 & -7 \\ 5 & 2 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} 8 & -3 \\ -8 & -1 \end{pmatrix}$ and $B = \begin{pmatrix} 3 & -8 \\ -7 & -3 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} 6 & -3 \\ 1 & -9 \end{pmatrix}$ and $B = \begin{pmatrix} -3 & -3 \\ -6 & 6 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} -3 & 3 \\ -2 & 8 \end{pmatrix}$ and $B = \begin{pmatrix} 1 & 3 \\ 5 & 8 \end{pmatrix}$, find $AB$.'),
    ('Given $A = \begin{pmatrix} -1 & 2 \\ 7 & 6 \end{pmatrix}$ and $B = \begin{pmatrix} 5 & -6 \\ 6 & 1 \end{pmatrix}$, find $A + B$.'),
    ('Given $A = \begin{pmatrix} 2 & 1 \\ 4 & -8 \end{pmatrix}$ and $B = \begin{pmatrix} 9 & -2 \\ -5 & -9 \end{pmatrix}$, find $AB$.')
) as p(txt)
where s.name = 'Matrix Operations' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the determinant of $\begin{pmatrix} 8 & 9 \\ 9 & 4 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} -5 & -3 \\ 1 & -2 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 3 & 9 \\ -2 & 6 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 8 & 1 \\ -1 & 6 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 6 & 5 \\ -4 & 2 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} -4 & -5 \\ 8 & 6 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} -4 & 8 \\ -8 & 7 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} -8 & -7 \\ -8 & -9 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 4 & -5 \\ -2 & -7 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} -5 & -9 \\ -3 & 7 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 5 & 2 \\ -8 & 6 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 6 & -9 \\ -9 & 8 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 8 & 4 \\ -9 & -9 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 7 & -1 \\ 8 & -9 \end{pmatrix}$.'),
    ('Find the determinant of $\begin{pmatrix} 7 & 4 \\ -4 & -6 \end{pmatrix}$.')
) as p(txt)
where s.name = 'Determinants' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether the set $\{(-5, 2), (-4, -3)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-3, 3), (2, -2)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-1, -2), (6, -5)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-1, 1), (3, -3)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(5, -3), (-2, 4)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-5, 4), (4, 6)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-6, -5), (2, 1)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-6, 4), (-6, 5)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-4, -5), (1, 4)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(6, -1), (3, -5)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(2, -6), (-3, -3)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(5, 3), (1, -2)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-6, -5), (4, -2)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(2, 3), (4, -6)\}$ spans $\mathbb{R}^2$.'),
    ('Determine whether the set $\{(-4, -1), (-6, -3)\}$ spans $\mathbb{R}^2$.')
) as p(txt)
where s.name = 'Vector Spaces' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Determine whether the vectors $(3, -4, 6)$ and $(5, -5, -2)$ are linearly independent.'),
    ('Determine whether the vectors $(-4, 3, -3)$ and $(3, 4, 2)$ are linearly independent.'),
    ('Determine whether the vectors $(-1, 6, 5)$ and $(-4, 6, 5)$ are linearly independent.'),
    ('Determine whether the vectors $(5, -5, 2)$ and $(5, -1, -6)$ are linearly independent.'),
    ('Determine whether the vectors $(-5, -3, -5)$ and $(-1, 3, 6)$ are linearly independent.'),
    ('Determine whether the vectors $(3, 3, 6)$ and $(-1, -6, 4)$ are linearly independent.'),
    ('Determine whether the vectors $(-2, 6, 1)$ and $(1, -3, -1)$ are linearly independent.'),
    ('Determine whether the vectors $(2, -4, 4)$ and $(3, 4, -5)$ are linearly independent.'),
    ('Determine whether the vectors $(6, 3, -2)$ and $(6, -3, 5)$ are linearly independent.'),
    ('Determine whether the vectors $(-5, -5, -2)$ and $(-4, 5, 6)$ are linearly independent.'),
    ('Determine whether the vectors $(4, -4, 5)$ and $(-1, -1, -5)$ are linearly independent.'),
    ('Determine whether the vectors $(-5, -6, -2)$ and $(1, -1, 6)$ are linearly independent.'),
    ('Determine whether the vectors $(-2, -5, -4)$ and $(-5, -4, 1)$ are linearly independent.'),
    ('Determine whether the vectors $(2, 2, 2)$ and $(-5, -6, -5)$ are linearly independent.'),
    ('Determine whether the vectors $(-1, 2, -5)$ and $(3, 3, 6)$ are linearly independent.')
) as p(txt)
where s.name = 'Linear Independence and Basis' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Given the linear transformation $T(x, y) = (-x - 6y,\ -2x + 6y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-5x + 5y,\ 2x - 3y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (3x + 2y,\ -4x + 4y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-4x - 4y,\ -2x - 2y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-2x + y,\ -4x - 5y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-4x - 2y,\ -2x + y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (6x - 5y,\ -x - 2y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-3x + 5y,\ 4x + y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (3x + 3y,\ -3x + y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-5x - 4y,\ -2x - 6y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-x + 3y,\ 6x - y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (x - y,\ 4x + 3y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-4x - 2y,\ -x + 3y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (5x - 3y,\ x - y)$, find $T(1, 0)$ and $T(0, 1)$.'),
    ('Given the linear transformation $T(x, y) = (-4x - y,\ -2x + 5y)$, find $T(1, 0)$ and $T(0, 1)$.')
) as p(txt)
where s.name = 'Linear Transformations' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the eigenvalues of $\begin{pmatrix} 5 & 3 \\ -1 & 4 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} -1 & 2 \\ 1 & -2 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} -5 & -1 \\ 4 & 3 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} -4 & 4 \\ -4 & 4 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 5 & -1 \\ 3 & 1 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 6 & -3 \\ 2 & -2 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 4 & -2 \\ -1 & 1 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} -2 & -2 \\ 2 & 4 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 6 & 3 \\ 3 & -5 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 3 & 4 \\ 2 & 2 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 2 & 1 \\ 4 & -6 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 3 & -3 \\ -3 & 4 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 6 & 1 \\ -2 & -3 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 4 & -4 \\ 2 & 3 \end{pmatrix}$.'),
    ('Find the eigenvalues of $\begin{pmatrix} 6 & 2 \\ -3 & -1 \end{pmatrix}$.')
) as p(txt)
where s.name = 'Eigenvalues and Eigenvectors' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Find the projection of vector $\vec{u} = (-8, -5)$ onto $\vec{v} = (-1, 8)$.'),
    ('Find the projection of vector $\vec{u} = (8, -1)$ onto $\vec{v} = (6, 3)$.'),
    ('Find the projection of vector $\vec{u} = (4, 6)$ onto $\vec{v} = (8, -4)$.'),
    ('Find the projection of vector $\vec{u} = (3, -8)$ onto $\vec{v} = (7, -5)$.'),
    ('Find the projection of vector $\vec{u} = (1, 5)$ onto $\vec{v} = (-6, -5)$.'),
    ('Find the projection of vector $\vec{u} = (-4, 3)$ onto $\vec{v} = (1, 2)$.'),
    ('Find the projection of vector $\vec{u} = (6, -2)$ onto $\vec{v} = (8, 7)$.'),
    ('Find the projection of vector $\vec{u} = (3, 7)$ onto $\vec{v} = (-5, 6)$.'),
    ('Find the projection of vector $\vec{u} = (6, 2)$ onto $\vec{v} = (-6, 1)$.'),
    ('Find the projection of vector $\vec{u} = (-7, -5)$ onto $\vec{v} = (-8, 2)$.'),
    ('Find the projection of vector $\vec{u} = (-5, -3)$ onto $\vec{v} = (-1, 8)$.'),
    ('Find the projection of vector $\vec{u} = (-3, -3)$ onto $\vec{v} = (2, 5)$.'),
    ('Find the projection of vector $\vec{u} = (6, -1)$ onto $\vec{v} = (4, -3)$.'),
    ('Find the projection of vector $\vec{u} = (-3, 5)$ onto $\vec{v} = (4, -8)$.'),
    ('Find the projection of vector $\vec{u} = (-2, 6)$ onto $\vec{v} = (5, 4)$.')
) as p(txt)
where s.name = 'Orthogonality and Least Squares' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('Diagonalize the matrix $\begin{pmatrix} -6 & 2 \\ 0 & 5 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -3 & 1 \\ 0 & -2 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} 3 & 5 \\ 0 & -5 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -4 & 3 \\ 0 & -1 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -3 & 1 \\ 0 & 1 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -2 & 4 \\ 0 & 4 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} 2 & 3 \\ 0 & 4 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} 3 & 4 \\ 0 & 3 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} 3 & 3 \\ 0 & -5 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -1 & 5 \\ 0 & 1 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -4 & 3 \\ 0 & 4 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} 3 & 1 \\ 0 & 3 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} 4 & 3 \\ 0 & -4 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -5 & 3 \\ 0 & -3 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.'),
    ('Diagonalize the matrix $\begin{pmatrix} -5 & 3 \\ 0 & -4 \end{pmatrix}$ if possible, or explain why it cannot be diagonalized.')
) as p(txt)
where s.name = 'Diagonalization' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');

insert into public.problem (problem, "sectionId")
select p.txt, s."sectionId"
from public.section s
cross join (values
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.7 & 0.3 \\ 0.3 & 0.7 \end{pmatrix}$. Find the state vector after one step given initial state $(75, 25)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.4 & 0.6 \\ 0.6 & 0.4 \end{pmatrix}$. Find the state vector after one step given initial state $(86, 14)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.2 & 0.8 \\ 0.8 & 0.2 \end{pmatrix}$. Find the state vector after one step given initial state $(59, 41)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.4 & 0.6 \\ 0.6 & 0.4 \end{pmatrix}$. Find the state vector after one step given initial state $(72, 28)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.6 & 0.4 \\ 0.4 & 0.6 \end{pmatrix}$. Find the state vector after one step given initial state $(32, 68)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.5 & 0.5 \\ 0.5 & 0.5 \end{pmatrix}$. Find the state vector after one step given initial state $(72, 28)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.3 & 0.7 \\ 0.7 & 0.3 \end{pmatrix}$. Find the state vector after one step given initial state $(33, 67)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.4 & 0.6 \\ 0.6 & 0.4 \end{pmatrix}$. Find the state vector after one step given initial state $(67, 33)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.6 & 0.4 \\ 0.4 & 0.6 \end{pmatrix}$. Find the state vector after one step given initial state $(55, 45)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.9 & 0.1 \\ 0.1 & 0.9 \end{pmatrix}$. Find the state vector after one step given initial state $(72, 28)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.2 & 0.8 \\ 0.8 & 0.2 \end{pmatrix}$. Find the state vector after one step given initial state $(59, 41)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.9 & 0.1 \\ 0.1 & 0.9 \end{pmatrix}$. Find the state vector after one step given initial state $(74, 26)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.6 & 0.4 \\ 0.4 & 0.6 \end{pmatrix}$. Find the state vector after one step given initial state $(62, 38)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.6 & 0.4 \\ 0.4 & 0.6 \end{pmatrix}$. Find the state vector after one step given initial state $(63, 37)$.'),
    ('A Markov chain has transition matrix $\begin{pmatrix} 0.7 & 0.3 \\ 0.3 & 0.7 \end{pmatrix}$. Find the state vector after one step given initial state $(66, 34)$.')
) as p(txt)
where s.name = 'Applications of Linear Algebra' and s."courseId" = (select "courseId" from public.course where name = 'Linear Algebra');
