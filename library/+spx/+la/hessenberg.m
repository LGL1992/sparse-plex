classdef hessenberg
% Functions to work with Hessenberg forms

methods(Static)


function H = qr_rq(H)
    % Takes a Hessenberg matrix H = QR and returns RQ
    % GVL4: algorithm 7.4.1
    import spx.la.givens.rotation;
    [n,n] = size(H);
    % Space for storing the c and s values
    cs = zeros(1, n);
    ss = zeros(1, n);
    % first the QR factorization
    % iterate over each column from first to last but one.
    for k=1:n-1
        % We need to process only one pair of rows
        % The diagonal element and immediate sub-diagonal element.
        a = H(k,k);
        b = H(k+1,k);
        % Compute the needed rotation for making b 0.
        [c,s] = rotation(a,b);
        % Store the rotation
        cs(k) = c;
        ss(k) = s;
        % Form the givens rotation matrix.
        G = [c s;-s c];
        % Rotate the two consecutive rows based submatrix
        H(k:k+1,k:n) = G'*H(k:k+1,k:n);
    end
    % Now the RQ formation
    for k=1:n-1
        G = [cs(k) ss(k); -ss(k) cs(k)];
        H(1:k+1,k:k+1) = H(1:k+1,k:k+1) * G;
    end
end % function


function [H, U0] = hess(A)
    % Reduction of a square matrix A into Hessenberg form 
    % using Householder reflections
    % GVL4: algorithm 7.4.2
    [n,n] = size(A);
    import spx.la.house;
    % Iterate over columns of A
    for k=1:n-2
        % Compute the householder reflector for k-th column
        % covering only sub-diagonal elements
        [v,beta] = house.gen(A(k+1:n,k));
        % Update the submatrix of A by premultiplication with the Projector
        A(k+1:n,k:n) = A(k+1:n,k:n) - (beta*v)*(v'*A(k+1:n,k:n));
        % Postmultiply with the same projector without affecting
        % the 0's in the k-th column
        A(:,k+1:n) = A(:,k+1:n) - (A(:,k+1:n)*v)*(beta*v)';
        % Store the householder reflection vector 
        A(k+2:n,k) = v(2:n-k);
    end
    % Extract the Hessenberg form
    H = triu(A,-1);
    if nargout > 1
        % Extract the orthogonal matrix U_0 such that
        % A = U_0 H U_0^T
        U0 = eye(n,n);
        U0(2:n,2:n) = house.q_back_accum_full(A(2:n,1:n-1));
    end
end % function



end % methods 

end % classdef

