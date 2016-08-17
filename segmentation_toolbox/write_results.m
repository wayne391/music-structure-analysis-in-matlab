function [ output_args ] = write_results(result, filename)
    fid = fopen(filename, 'w');
    for i =1:length(result)-1
        fprintf(fid,'%f %f %s\n' ,result(i), result(i+1), 'unknown');
    end
    fclose(fid);
end

