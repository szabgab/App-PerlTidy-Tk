package App::PerlTidy::Tk;
use strict;
use warnings;
use 5.008;

use Cwd qw(getcwd);
use Perl::Tidy;
use Tk;
use Tk::Dialog;
use Tk::FileSelect;

our $VERSION = '0.01';

sub run {
    my ($class) = @_;
    my $self = bless {}, $class;
    $self->{top} = MainWindow->new;
    $self->create_menu;
    MainLoop;
}


sub create_menu {
    my ($self) = @_;

    my $main_menu = $self->{top}->Menu();

    my $file_menu = $main_menu->cascade(-label => 'File');
    $file_menu->command(-label => 'Open', -command => sub { $self->show_open(); });
    $file_menu->command(-label => 'Quit', -command => sub { $self->exit_app(); });

    my $action_menu = $main_menu->cascade(-label => 'Action');
    $action_menu->command(-label => 'Tidy', -command => \&run_tidy);

    my $about_menu = $main_menu->cascade(-label => 'Help', -underline => 0);
    $about_menu->command(-label => 'About', -command => sub { $self->show_about; });

    $self->{top}->configure(-menu => $main_menu);
}

sub show_open {
    my ($self) = @_;

    my $start_dir = getcwd();
    my $file_selector = $self->{top}->FileSelect(-directory => $start_dir);
    my $filename = $file_selector->Show;
    if ($filename and -f $filename) {
        if (open my $fh, '<', $filename) {
            local $/ = undef;
            my $content = <$fh>;
            #$text->insert("0.0", $content);
        } else {
            print "TODO: Report error $! for '$filename'\n";
        }
    }
}


sub run_tidy {
    my ($self) = @_;

    print("run\n");
}

sub show_about {
    my ($self) = @_;
    my $text = <<"TEXT";
Version: $VERSION
Tk: $Tk::VERSION
Perl::Tidy: $Perl::Tidy::VERSION
Perl $]

Create by Gabor Szabo
Thanks to my Patreon supporters
TEXT

    my $dialog = $self->{top}->Dialog(
        -title   => 'About App::PerlTidy::Tk',
        -popover => $self->{top},
        -text    => $text,
        -justify => 'left',
    );
    $dialog->Show;
}

sub exit_app {
    my ($self) = @_;

    print("TODO: save changes before exit? Same when user click on x\n");
    exit;
}

1;
