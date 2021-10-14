function [maplmc, timvec, file_str] = load_fredo_data( file_number, type )
% *WAVE*
%
% LOAD FREDO DATA  loads data of the type given by the Marseille
%                  experimental group
%
% INPUT
% filenumber - an index into the cell arrays below
% type - either 'stim' or 'blank'
%
% OUTPUT
% maplmc - trial datacube (r,c,t,trials)
% timvec - time vector for these experiments (1,t)
% file_str - file string for the loaded data (str)
%

file_list = {
    '080523alex_lmmap_scond07' % 10ms
    '080523alex_lmmap_scond09' % 50ms
    '080507alex_lmmap_scond11' % 100ms
    '080411constantesandrine_lmmap_scond01' % 300ms
    '110121alexbloblyle_lmmap_scond06' % 600ms, monkey 3 (GR)
    };

file_list_blanks = {
    '080507alex_lmmap_scond00'
    '080507alex_lmmap_scond13'
    '080523alex_lmmap_scond00'
    '080523alex_lmmap_scond11'
    '110121alexbloblyle_lmmap_scond00' % monkey 3 (GR)
    '080411constantesandrine_lmmap_scond00'
    '051202alex_lmmap_scond01' % monkey 2 (NO), BLANK1
    '051202alex_lmmap_scond05'}; % monkey 2 (NO), BLANK2
%'080411constantesandrine_lmmap_scond05'};  % corrupt tarball

file_list_matched1 = {
    '080523alex_lmmap_scond08' % 10ms
    '080523alex_lmmap_scond09' % 50ms
    };

file_list_matched2 = {
    '080507alex_lmmap_scond09' % 50ms, matched to the 100ms data session
    '080507alex_lmmap_scond11' % 100ms
    };

file_list_matched3 = {
    '080208alex_lmmap_scond09' % 100ms
    '080208alex_lmmap_scond10' % 100ms
    '080208alex_lmmap_scond11' % 300ms
    '080208alex_lmmap_scond12' % 300ms
    };

fig_2b = {
    '080523alex_lmmap_scond09' % 50ms
    '080507alex_lmmap_scond13' % 2nd blank dataset
    '080523alex_lmmap_scond07' % 10ms
    '080507alex_lmmap_scond11' % 100ms
    '110121alexbloblyle_lmmap_scond06' % 600ms, monkey 3 (GR)
    };

sync_test = {
    '080424alexretino_lmmap_scond11' % UPRIGHT
    '080424alexretino_lmmap_scond13' % UPLEFT
    };

monkey_NO = {
    '051202alex_lmmap_scond01'
    '051202alex_lmmap_scond02'
    };

old_dir = pwd;
cd('~/Documents/data/int/alex')

if strcmp( type, 'stim' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( file_list{file_number} );
    file_str = file_list{file_number};
elseif strcmp( type, 'blank' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( file_list_blanks{file_number} );
    file_str = file_list_blanks{file_number};
elseif strcmp( type, 'matched1' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( file_list_matched1{file_number} );
    file_str = file_list_matched1{file_number};
elseif strcmp( type, 'matched2' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( file_list_matched2{file_number} );
    file_str = file_list_matched2{file_number};
elseif strcmp( type, 'matched3' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( file_list_matched3{file_number} );
    file_str = file_list_matched3{file_number};
elseif strcmp( type, 'fig2b' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( fig_2b{file_number} );
    file_str = fig_2b{file_number};
elseif strcmp( type, 'synctest' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( sync_test{file_number} );
    file_str = sync_test{file_number};
elseif strcmp( type, 'monkeyNO' )
    [maplmc,sl,xs,ys,~,timvec]=readfloat( monkey_NO{file_number} );
    file_str = monkey_NO{file_number};
else
    error('Wrong type specification')
end

cd(old_dir)

maplmc = reshape( maplmc, [xs/2,ys/2,sl(2),sl(3)] );
