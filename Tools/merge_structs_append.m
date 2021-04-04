function [ s3 ] = merge_structs_append( s1, s2 )
% combine two structs, that share the same fields, s2's values for
% those fields are appended after s1's values

s3 = s1;

fields = fieldnames(s2);
for i = 1:length(fields),
    field = char(fields(i));
    s3.(field) = [s1.(field); s2.(field)];
end

end

