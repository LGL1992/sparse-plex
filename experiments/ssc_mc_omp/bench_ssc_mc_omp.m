clear all;
close all;
clc;
configs = cell(1, 5);
configs{1} = create_config([1 1 1 1 1 1], 1, '1-1');
configs{2} = create_config([2 1 1 1 1 1], 4, '2.1-4');
configs{3} = create_config([4 2 1 1 1 1], 4, '42.1-4');
configs{4} = create_config([2 2 2 2 2 2], 4, '2-4');
configs{5} = create_config([2 2 2 2 2 2], 8, '2-8');

nc = numel(configs);

% We can control from here the configurations for which the script will be run.
% It is possible to run the script one by one for each configuration.
for c=1:2
    config = configs{c};
    if isempty(config)
        continue;
    end
    solver_name = sprintf('ssc_mc_omp_%s', config.name);
    result = spx.cluster.ssc.util.bench_subspace_preservation(@ssc_mc_omp, solver_name, config);
    result.config = config;
    filepath = sprintf('bin/%s.mat', solver_name);
    save(filepath, 'result');
end
