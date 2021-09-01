function [W0, w0] = getW0(r)

    w0 = ones(getNTags(r),1);
    if ~isempty(r.MarkW)
        w0(r.MarkW) = r.W;
    end
    if r.UseEllips
        w0(end-size(r.def.EllipsMarker,1)+1:end) = r.WEllips; % Ellipse
    end
    w0 = [w0;w0;w0];
    W0 =diag(w0); W0=W0/norm(W0);
end