# Assignment3

# Instructions

1. Read about Lexico Feasibility in sections 2.1, 2.2 of "Linear Complementarity, Linear and Nonlinear
   Programming" by Katta Murty (book linked on Brightspace and below).
2. Implement the Lexico Feasible variant of Lemke's method in `solve_lcp.jl`,
   so that all tests pass.
3. Come up with a real-world problem that can be modeled as an LCP. Code up your model of the problem, 
   and try to solve it using your impelementation of Lemke's method. Implement
   this in the file `test/my_problem.jl`. In the function signature, describe
   you problem, what it is modeling, and your findings from modeling it and
   solving it. E.g. how long did it take roughly to solve? What is your
   interpretation of the solution? Is an LCP (LP/QP/NEP) a good model of your
   problem? If not, what type of problem formulation would be more appropriate?
4. Upload a pdf to this repository containing your solution to the following:
   Consider the problem:

   x_opt = argmin_x  (x-w)^2
   
   s.t.    x >= 0

   Define the piecewise-linear function which maps w->x_opt. Call this function
   K(w).

   Now consider the following problem:

   (w_opt, x_opt) = argmin_(w,x) ([x; w] - [v1; v2])'([x; w] - [v1; v2])
   
   s.t.          x = K(w)

   Define the piecewise-linear function which maps (v1,v2)->(w_opt, x_opt). 


# Murty book
[Linear Complementarity, Linear and Nonlinear
Programming](http://www-personal.umich.edu/~murty/books/linear_complementarity_webbook/lcp-complete.pdf)

# Julia resources

- [Julia Manual](https://docs.julialang.org/en/v1/manual/getting-started/)
- [Julia Package/Environment Guide](https://pkgdocs.julialang.org/v1/)
- [JuMP (JuliaMathematicalProgramming) Documentation](https://jump.dev/JuMP.jl/stable/)
- [Julia workflow tips](https://m3g.github.io/JuliaNotes.jl/stable/workflow/)
- [Julia Academy](https://juliaacademy.com/courses)
- [Algorithms for Optimization book with Julia Examples](https://algorithmsbook.com/optimization/)
