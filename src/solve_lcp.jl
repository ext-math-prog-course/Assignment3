function lexico_minimum(q, Bi, d, contention; tol=1e-6)
    n = length(q)
    min_val = minimum(q[contention] ./ d[contention])
    for i = 1:n
        if (contention[i] && ((q[i] / d[i]) > (min_val + tol)))
            contention[i] = false
        end
    end
    if count(contention) > 1
        for j = 1:n
            min_val = minimum(Bi[contention, j] ./ d[contention])

            for i = 1:n
                if (contention[i] && ((Bi[i, j] / d[i]) > (min_val + tol))) 
                    contention[i] = false
                end
            end
            count(contention) == 1 && break
        end
    end
    return argmax(contention)
end

"""
Solve

    LCP(M, q): 
        find w ∈ ℝⁿ, z ∈ ℝⁿ
        s.t.    w - Mz = q
                w ≥ 0
                z ≥ 0
                wᵢ⋅zᵢ = 0, i ∈ {1,...,n}

using Lemke's method.

Returns named tuple (; w, z, ret)
where ret = 
    {   -1  :   failure
        0   :   ray termination
        1   :   success  }
    
It is assumed that the vector q is nondegenerate.
"""
function solve_lcp(M, q; max_iters=50, tol=1e-6, debug=true)
    n = length(q)
    if size(M) != (n,n)
        w = q
        z = zeros(Float64, n)
        ret = -1
        return (; w, z, ret)
    end
    if all(q .> -tol)
        z = zeros(Float64, n)
        w = q
        ret = 1
        return (; w, z, ret)
    end

    T = [I(n) -M -ones(n) q]
    A = [I(n) -M -ones(n)]
    basis = collect(1:n)
    t = argmin(q)

    basis[t] = 2n+1

    pivot = T[t, :] ./ T[t, 2n + 1]
    T -= T[:, 2n + 1] * pivot'
    T[t, :] = pivot

    entering_ind = t+n
    iters = 0
    ret = 1
    while 2*n+1 in basis
        d = T[:, entering_ind]
        B = A[:, basis]
        q = T[:, end]
        contention = d .> tol
        if !any(contention)
            ret = 0
            break
        else
            t = lexico_minimum(q, T[:,1:n], d, contention)
            pivot = T[t, :] ./ T[t, entering_ind]
            T -= T[:, entering_ind] * pivot'
            T[t, :] = pivot
            exiting_ind = basis[t]
            basis[t] = entering_ind
            entering_ind = mod(exiting_ind + n, 2n)
            if entering_ind == 0
                entering_ind = 2n
            end
        end
    end
    vars = zeros(Float64, 2n+1)
    vars[basis] = T[:, end]
    w = vars[1:n]
    z = vars[n+1:2n]
    return (; w, z, ret)
end
