use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'App::PerlTidy::Tk',
    AUTHOR       => q{Gabor Szabo <szabgab@cpan.org>},
    VERSION_FROM => 'lib/App/PerlTidy/Tk.pm',
    ABSTRACT     => 'Tk based GUI to experiment with PerlTidy configuration options',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'Tk'         => 0,
        'Perl::Tidy' => 0
    },
    EXE_FILES => ['bin/perltidy-tk'],
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
