function plotRef(R,t,sf)

if nargin==2, sf = 0.05; end

% keyboard
R=squeeze(R(:,:,t));

O=R(1:3,4);
X= O + sf *R(1:3,1);
Y= O + sf *R(1:3,2);
Z= O + sf *R(1:3,3);


plot3([O(1) X(1)],[O(2) X(2)],[O(3) X(3)],'r','linewidth',2); hold on
plot3([O(1) Y(1)],[O(2) Y(2)],[O(3) Y(3)],'g','linewidth',2);
plot3([O(1) Z(1)],[O(2) Z(2)],[O(3) Z(3)],'b','linewidth',2);

axis('manual')
axis equal

drawnow