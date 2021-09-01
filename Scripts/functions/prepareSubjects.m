function subjects = prepareSubjects(subjectsToUse)
    % All subjects info
    subjects(1).name = 'Subject1';
    subjects(1).armTested = 'left';
    subjects(2).name = 'Subject2';
    subjects(2).armTested = 'right';
    subjects(3).name = 'Subject3';
    subjects(3).armTested = 'left';
    subjects(4).name = 'Subject4';
    subjects(4).armTested = 'left';
    subjects(5).name = 'Subject5';
    subjects(5).armTested = 'left';
    subjects(6).name = 'Subject6';
    subjects(6).armTested = 'left';
    subjects(7).name = 'Subject7';
    subjects(7).armTested = 'left';
    subjects(8).name = 'Subject8';
    subjects(8).armTested = 'left';
    
    % Keep only relevent
    subjects = subjects(subjectsToUse);
end
