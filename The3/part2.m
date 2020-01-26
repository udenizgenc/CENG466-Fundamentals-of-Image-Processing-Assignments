%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390

clc;
clear;
mkdir('Segmentation_results_algo2');
mkdir('Segmentation_results_algo1');
B1 = imread('CENG466_THE3_Part2/8049.jpg');
segment(B1,'1');
B2 = imread('CENG466_THE3_Part2/12003.jpg');
segment(B2,'2');
B3 = imread('CENG466_THE3_Part2/35058.jpg');
segment(B3,'3');
B4 = imread('CENG466_THE3_Part2/35070.jpg');
segment(B4,'4');
B5 = imread('CENG466_THE3_Part2/41004.jpg');
segment(B5,'5');
B6 = imread('CENG466_THE3_Part2/42044.jpg');
segment(B6,'6');
B7 = imread('CENG466_THE3_Part2/42078.jpg');
segment(B7,'7');
B8 = imread('CENG466_THE3_Part2/94079.jpg');
segment(B8,'8');
B9 = imread('CENG466_THE3_Part2/100075.jpg');
segment(B9,'9');
B10 = imread('CENG466_THE3_Part2/100080.jpg');
segment(B10,'10');
B11 = imread('CENG466_THE3_Part2/105019.jpg');
segment(B11,'11');
B12 = imread('CENG466_THE3_Part2/105053.jpg');
segment(B12,'12');
B13 = imread('CENG466_THE3_Part2/106025.jpg');
segment(B13,'13');
B14 = imread('CENG466_THE3_Part2/108041.jpg');
segment(B14,'14');
B15 = imread('CENG466_THE3_Part2/108073.jpg');
segment(B15,'15');
B16 = imread('CENG466_THE3_Part2/112082.jpg');
segment(B16,'16');
B17 = imread('CENG466_THE3_Part2/113009.jpg');
segment(B17,'17');
B18 = imread('CENG466_THE3_Part2/113044.jpg');
segment(B18,'18');
B19 = imread('CENG466_THE3_Part2/134052.jpg');
segment(B19,'19');
B20 = imread('CENG466_THE3_Part2/135069.jpg');
segment(B20,'20');
B21 = imread('CENG466_THE3_Part2/163014.jpg');
segment(B21,'21');
B22 = imread('CENG466_THE3_Part2/268002.jpg');
segment(B22,'22');
B23 = imread('CENG466_THE3_Part2/314016.jpg');
segment(B23,'23');
B24 = imread('CENG466_THE3_Part2/317080.jpg');
segment(B24,'24');
B25 = imread('CENG466_THE3_Part2/326038.jpg');
segment(B25,'25');


function outputimage = segment(I,a)

currentFolder = pwd;
%% parameters
% kmeans parameter
K    = 8;                  % Cluster Numbers
% meanshift parameter
bw   = 0.2;                % Mean Shift Bandwidth
% ncut parameters
SI   = 5;                  % Color similarity
SX   = 6;                  % Spatial similarity
r    = 1.5;                % Spatial threshold (less than r pixels apart)
sNcut = 0.21;              % The smallest Ncut value (threshold) to keep partitioning
sArea = 80;                % The smallest size of area (threshold) to be accepted as a segment
%% compare
Ikm2         = Km2(I,K);                    % Kmeans (color + spatial)
[Ims2, Nms2] = Ms2(I,bw);                   % Mean Shift (color + spatial)

%% show
x= append(currentFolder,'\Segmentation_results_algo1');
x1= append(a,'.jpg');
folder = x;
imwrite(Ikm2,fullfile(folder,x1),'jpg');
x= append(currentFolder,'\Segmentation_results_algo2');
x2= append(a,'.jpg');
folder = x;
imwrite(Ims2,fullfile(folder,x2),'jpg');
end

function [Ims Kms] = Ms2(I,bandwidth)

%% color + spatial (option: bandwidth)
I = im2double(I);
[x,y] = meshgrid(1:size(I,2),1:size(I,1)); L = [y(:)/max(y(:)),x(:)/max(x(:))]; % Spatial Features
C = reshape(I,size(I,1)*size(I,2),3); X = [C,L];                                % Color & Spatial Features
%% MeanShift Segmentation
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(X',bandwidth);      % MeanShiftCluster
for i = 1:length(clustMembsCell)                                                % Replace Image Colors With Cluster Centers
X(clustMembsCell{i},:) = repmat(clustCent(:,i)',size(clustMembsCell{i},2),1); 
end
Ims = reshape(X(:,1:3),size(I,1),size(I,2),3);                                  % Segmented Image
Kms = length(clustMembsCell);

end

function Ikm = Km2(I,K)

%% color + spatial (option: K (Number of Clusters))
I = im2double(I);
[x,y] = meshgrid(1:size(I,2),1:size(I,1));            % Spatial Features
L = [y(:)/max(y(:)),x(:)/max(x(:))];
C = reshape(I,size(I,1)*size(I,2),3);                 % Color Features 
F = [C,L];                                            % Color & Spatial Features
%% Kmeans Segmentation
CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
DAL   = zeros(size(F,1),K+2);                         % Distances and Labels
KMI   = 10;                                           % K-means Iteration
for n = 1:KMI
   for i = 1:size(F,1)
      for j = 1:K  
        DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
      end
      [Distance CN] = min(DAL(i,1:K));                % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
end

X = zeros(size(F));
for i = 1:K
idx = find(DAL(:,K+1) == i);
X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
end
Ikm = reshape(X(:,1:3),size(I,1),size(I,2),3);

end

function [clustCent,data2cluster,cluster2dataCell] = MeanShiftCluster(dataPts,bandWidth,plotFlag)
%perform MeanShift Clustering of data using a flat kernel
%
% ---INPUT---
% dataPts           - input data, (numDim x numPts)
% bandWidth         - is bandwidth parameter (scalar)
% plotFlag          - display output if 2 or 3 D    (logical)
% ---OUTPUT---
% clustCent         - is locations of cluster centers (numDim x numClust)
% data2cluster      - for every data point which cluster it belongs to (numPts)
% cluster2dataCell  - for every cluster which points are in it (numClust)
% 
% Bryan Feldman 02/24/06
% MeanShift first appears in
% K. Funkunaga and L.D. Hosteler, "The Estimation of the Gradient of a
% Density Function, with Applications in Pattern Recognition"

%*** Check input ****
if nargin < 2
    error('no bandwidth specified')
end

if nargin < 3
    plotFlag = false;
end

%**** Initialize stuff ***
[numDim,numPts] = size(dataPts);
numClust        = 0;
bandSq          = bandWidth^2;
initPtInds      = 1:numPts;
maxPos          = max(dataPts,[],2);                          %biggest size in each dimension
minPos          = min(dataPts,[],2);                          %smallest size in each dimension
boundBox        = maxPos-minPos;                        %bounding box size
sizeSpace       = norm(boundBox);                       %indicator of size of data space
stopThresh      = 1e-3*bandWidth;                       %when mean has converged
clustCent       = [];                                   %center of clust
beenVisitedFlag = zeros(1,numPts,'uint8');              %track if a points been seen already
numInitPts      = numPts;                               %number of points to posibaly use as initilization points
clusterVotes    = zeros(1,numPts,'uint16');             %used to resolve conflicts on cluster membership


while numInitPts

    tempInd         = ceil( (numInitPts-1e-6)*rand);        %pick a random seed point
    stInd           = initPtInds(tempInd);                  %use this point as start of mean
    myMean          = dataPts(:,stInd);                           % intilize mean to this points location
    myMembers       = [];                                   % points that will get added to this cluster                          
    thisClusterVotes    = zeros(1,numPts,'uint16');         %used to resolve conflicts on cluster membership

    while 1     %loop untill convergence
        
        sqDistToAll = sum((repmat(myMean,1,numPts) - dataPts).^2);    %dist squared from mean to all points still active
        inInds      = find(sqDistToAll < bandSq);               %points within bandWidth
        thisClusterVotes(inInds) = thisClusterVotes(inInds)+1;  %add a vote for all the in points belonging to this cluster
        
        
        myOldMean   = myMean;                                   %save the old mean
        myMean      = mean(dataPts(:,inInds),2);                %compute the new mean
        myMembers   = [myMembers inInds];                       %add any point within bandWidth to the cluster
        beenVisitedFlag(myMembers) = 1;                         %mark that these points have been visited
        
        %*** plot stuff ****
        if plotFlag
            figure(12345),clf,hold on
            if numDim == 2
                plot(dataPts(1,:),dataPts(2,:),'.')
                plot(dataPts(1,myMembers),dataPts(2,myMembers),'ys')
                plot(myMean(1),myMean(2),'go')
                plot(myOldMean(1),myOldMean(2),'rd')
                pause(.1)
            end
        end

        %**** if mean doesn't move much stop this cluster ***
        if norm(myMean-myOldMean) < stopThresh
            
            %check for merge posibilities
            mergeWith = 0;
            for cN = 1:numClust
                distToOther = norm(myMean-clustCent(:,cN));     %distance from posible new clust max to old clust max
                if distToOther < bandWidth/2                    %if its within bandwidth/2 merge new and old
                    mergeWith = cN;
                    break;
                end
            end
            
            
            if mergeWith > 0    % something to merge
                clustCent(:,mergeWith)       = 0.5*(myMean+clustCent(:,mergeWith));             %record the max as the mean of the two merged (I know biased twoards new ones)
                %clustMembsCell{mergeWith}    = unique([clustMembsCell{mergeWith} myMembers]);   %record which points inside 
                clusterVotes(mergeWith,:)    = clusterVotes(mergeWith,:) + thisClusterVotes;    %add these votes to the merged cluster
            else    %its a new cluster
                numClust                    = numClust+1;                   %increment clusters
                clustCent(:,numClust)       = myMean;                       %record the mean  
                %clustMembsCell{numClust}    = myMembers;                    %store my members
                clusterVotes(numClust,:)    = thisClusterVotes;
            end

            break;
        end

    end
        
    initPtInds      = find(beenVisitedFlag == 0);           %we can initialize with any of the points not yet visited
    numInitPts      = length(initPtInds);                   %number of active points in set

end

[val,data2cluster] = max(clusterVotes,[],1);                %a point belongs to the cluster with the most votes

%*** If they want the cluster2data cell find it for them
if nargout > 2
    cluster2dataCell = cell(numClust,1);
    for cN = 1:numClust
        myMembers = find(data2cluster == cN);
        cluster2dataCell{cN} = myMembers;
    end
end
end
