atreplinit() do repl
    try
        @eval using Revise
    catch e
        @warn "Error initializing Revise" exception=(e, catch_backtrace())
    end

    startup_opts = split(get(ENV, "JULIA_STARTUP_FILE_OPTS", ""), ",")

    if in("datascience", startup_opts)
        try
            @eval using Arrow, CSV, Chain, DataFrames, PrettyTables, StatsBase, Tables
        catch e
            @warn "Error initializing Datascience packages" exception=(e, catch_backtrace())
        end
    end
end
