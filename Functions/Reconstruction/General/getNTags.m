function NTAG = getNTags(r)
    NTAG = biorbd('nmarkers', r.model);
end