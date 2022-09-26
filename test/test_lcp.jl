using LinearAlgebra
using SparseArrays
using OSQP

function test_solve(M, q, w, z, ret)
    @test ret == 1
    @test norm(q - (w - M*z)) <= 1e-4
    @test all(w .> -1e-6)
    @test all(z .> -1e-6)
    @test all((w .* z) .< 1e-6)
end

function check_feasibility(M, q)
    dim = length(q)
    m = OSQP.Model()
    OSQP.setup!(m; P = sparse(I(dim)), q = zeros(dim), A = sparse([I(dim); M]), l = [zeros(dim); -q], verbose=false, polish=true)
    ret = OSQP.solve!(m)
    return ret.info.status_val == 1
end

@testset "lcp_test" begin
    n = 25
    for i in 1:30
        M = randn(10,n)
        M = M'*M
        q = randn(n)
        (; w, z, ret) = solve_lcp(M,q)
        if ret == 1
            test_solve(M, q, w, z, ret)
        else
            @test !check_feasibility(M, q)
        end
    end
end

@testset "bmg_test" begin
    A = [0 1 -1.0; -1 0 1; 1 -1 0]
    B = -A
    Z = zeros(3,3)
    e = ones(3)
    z = zeros(3)
    o = zeros(2,2)
    M = [Z A -e z; B' Z z -e; [e' z'; z' e'] o]
    q = [zeros(6); -ones(2)]
    (; w, z, ret) = solve_lcp(M,q)
    println(z)
    test_solve(M, q, w, z, ret)
end


