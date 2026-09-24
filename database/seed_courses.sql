-- Adds Algebra 2, Trigonometry, Geometry, Calculus 1, and Linear Algebra, each with a full
-- set of curriculum sections. Non-destructive and safe to re-run: every insert is guarded by
-- a NOT EXISTS check, so re-running this script will not create duplicate courses/sections
-- and will not touch your existing Algebra 1 / Calculus 2 data.
-- Run this in the Supabase SQL editor against your live project.

-- Your existing course/section rows were inserted with explicit ids (e.g. via the Table
-- Editor), which doesn't advance the courseId/sectionId auto-increment sequences. Resync
-- them to the current max id first, or the inserts below fail with a duplicate key error.
select setval(pg_get_serial_sequence('public.course', 'courseId'), coalesce((select max("courseId") from public.course), 0));
select setval(pg_get_serial_sequence('public.section', 'sectionId'), coalesce((select max("sectionId") from public.section), 0));

do $$
declare
  v_course_id bigint;
begin
  -- =========================================================================
  -- Algebra 1 (existing course - fill out the rest of its sections;
  -- your existing "Quadratic Equations" section is left untouched)
  -- =========================================================================
  select "courseId" into v_course_id from public.course where name = 'Algebra 1';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Variables and Expressions'),
    ('Solving Linear Equations'),
    ('Solving Linear Inequalities'),
    ('Graphing Linear Equations'),
    ('Writing Linear Equations'),
    ('Systems of Linear Equations'),
    ('Exponents and Exponential Functions'),
    ('Polynomials and Factoring'),
    ('Radical Expressions and Equations')
  ) as v(name)
  where v_course_id is not null and not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

  -- =========================================================================
  -- Calculus 2 (existing course - fill out the rest of its sections;
  -- your existing "Taylor Series" section is left untouched)
  -- =========================================================================
  select "courseId" into v_course_id from public.course where name = 'Calculus 2';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Integration by Parts'),
    ('Trigonometric Integrals and Substitution'),
    ('Partial Fraction Decomposition'),
    ('Improper Integrals'),
    ('Applications of Integration: Area and Volume'),
    ('Arc Length and Surface Area'),
    ('Sequences and Their Limits'),
    ('Infinite Series and Convergence Tests'),
    ('Power Series and Radius of Convergence')
  ) as v(name)
  where v_course_id is not null and not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

  -- =========================================================================
  -- Algebra 2
  -- =========================================================================
  insert into public.course (name)
  select 'Algebra 2'
  where not exists (select 1 from public.course c where c.name = 'Algebra 2');

  select "courseId" into v_course_id from public.course where name = 'Algebra 2';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Linear Equations and Inequalities Review'),
    ('Systems of Linear Equations'),
    ('Quadratic Functions and Equations'),
    ('Polynomial Functions'),
    ('Rational Expressions and Equations'),
    ('Radical Expressions and Equations'),
    ('Exponential Functions'),
    ('Logarithmic Functions'),
    ('Sequences and Series'),
    ('Conic Sections')
  ) as v(name)
  where not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

  -- =========================================================================
  -- Trigonometry
  -- =========================================================================
  insert into public.course (name)
  select 'Trigonometry'
  where not exists (select 1 from public.course c where c.name = 'Trigonometry');

  select "courseId" into v_course_id from public.course where name = 'Trigonometry';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Angles and Radian Measure'),
    ('Right Triangle Trigonometry'),
    ('The Unit Circle'),
    ('Graphs of Trigonometric Functions'),
    ('Trigonometric Identities'),
    ('Solving Trigonometric Equations'),
    ('Law of Sines and Law of Cosines'),
    ('Inverse Trigonometric Functions'),
    ('Polar Coordinates'),
    ('Vectors')
  ) as v(name)
  where not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

  -- =========================================================================
  -- Geometry
  -- =========================================================================
  insert into public.course (name)
  select 'Geometry'
  where not exists (select 1 from public.course c where c.name = 'Geometry');

  select "courseId" into v_course_id from public.course where name = 'Geometry';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Points, Lines, and Planes'),
    ('Angles and Angle Relationships'),
    ('Triangle Congruence'),
    ('Triangle Similarity'),
    ('Polygons and Quadrilaterals'),
    ('Circles'),
    ('Area and Perimeter'),
    ('Surface Area and Volume'),
    ('Coordinate Geometry'),
    ('Transformations')
  ) as v(name)
  where not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

  -- =========================================================================
  -- Calculus 1
  -- =========================================================================
  insert into public.course (name)
  select 'Calculus 1'
  where not exists (select 1 from public.course c where c.name = 'Calculus 1');

  select "courseId" into v_course_id from public.course where name = 'Calculus 1';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Limits and Continuity'),
    ('The Derivative Definition'),
    ('Differentiation Rules'),
    ('Applications of Derivatives'),
    ('Related Rates'),
    ('Optimization Problems'),
    ('The Mean Value Theorem'),
    ('Antiderivatives and Indefinite Integrals'),
    ('The Definite Integral'),
    ('The Fundamental Theorem of Calculus')
  ) as v(name)
  where not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

  -- =========================================================================
  -- Linear Algebra
  -- =========================================================================
  insert into public.course (name)
  select 'Linear Algebra'
  where not exists (select 1 from public.course c where c.name = 'Linear Algebra');

  select "courseId" into v_course_id from public.course where name = 'Linear Algebra';

  insert into public.section (name, "courseId")
  select v.name, v_course_id
  from (values
    ('Systems of Linear Equations and Matrices'),
    ('Matrix Operations'),
    ('Determinants'),
    ('Vector Spaces'),
    ('Linear Independence and Basis'),
    ('Linear Transformations'),
    ('Eigenvalues and Eigenvectors'),
    ('Orthogonality and Least Squares'),
    ('Diagonalization'),
    ('Applications of Linear Algebra')
  ) as v(name)
  where not exists (
    select 1 from public.section s where s."courseId" = v_course_id and s.name = v.name
  );

end $$;
