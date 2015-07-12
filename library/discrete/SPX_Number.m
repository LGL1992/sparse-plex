classdef SPX_Number
    %SPX_NUMBER Utility functions for number manipulation
    
    properties
    end
    
    methods (Static)

        function result = is_integer(value)
            result = (mod(value, 1) == 0);
        end

        function result = is_positive_integer(value)
            result = (value > 0) & (mod(value, 1) == 0);
        end

        function result = is_negative_integer(value)
            result = (value < 0) & (mod(value, 1) == 0);
        end

        function result = is_odd(value)
            result = (mod(value, 2) == 1);
        end

        function result = is_even(value)
            result = (mod(value, 2) == 0);
        end

        function result = is_odd_natural(value)
            result = (mod(value, 2) == 1) & (value > 0);
        end

        function result = is_even_natural(value)
            result = (mod(value, 2) == 0) & (value > 0);
        end

        function [a, b] =  findIntegerFactorsCloseToSquarRoot(n)
            % a cannot be greater than the square root of n
            % b cannot be smaller than the square root of n
            % we get the maximum allowed value of a
            amax = floor(sqrt(n));
            if 0 == rem(n, amax)
                % special case where n is a square number
                a = amax;
                b = n / a;
                return;
            end
            % Get its prime factors of n
            primeFactors  = factor(n);
            % Start with a factor 1 in the list of candidates for a
            candidates = [1];
            for i=1:numel(primeFactors)
                % get the next prime factor
                f = primeFactors(i);
                % Add new candidates which are obtained by multiplying
                % existing candidates with the new prime factor f
                % Set union ensures that duplicate candidates are removed
                candidates  = union(candidates, f .* candidates);
                % throw out candidates which are larger than amax
                candidates(candidates > amax) = [];
            end
            % Take the largest factor in the list d
            a = candidates(end);
            b = n / a;
        end
    end
    
end

