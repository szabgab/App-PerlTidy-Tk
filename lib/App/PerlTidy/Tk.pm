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

my %config = (
    '--indent-columns' => 4,
    '--maximum-line-length' => 80,
    '--variable-maximum-line-length' => undef,
    '--whitespace-cycle' => 0,
);


sub run {
    my ($class) = @_;
    my $self = bless {}, $class;

    $self->{top} = MainWindow->new;
    $self->create_menu;
    $self->create_text_widget;

    MainLoop;
}


sub create_menu {
    my ($self) = @_;

    my $main_menu = $self->{top}->Menu();

    my $file_menu = $main_menu->cascade(-label => 'File');
    $file_menu->command(-label => 'Open', -command => sub { $self->show_open(); });
    $file_menu->command(-label => 'Quit', -command => sub { $self->exit_app(); });

    my $action_menu = $main_menu->cascade(-label => 'Action');
    $action_menu->command(-label => 'Tidy', -command => sub { $self->run_tidy; });

    my $about_menu = $main_menu->cascade(-label => 'Help', -underline => 0);
    $about_menu->command(-label => 'About', -command => sub { $self->show_about; });

    $self->{top}->configure(-menu => $main_menu);
}

sub create_text_widget {
    my ($self) = @_;

    $self->{text} = $self->{top}->Text(
        -state => 'normal'
    );
    $self->{text}->pack(-fill => 'both', -expand => 1);
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
            $self->{text}->delete("0.0", 'end');
            $self->{text}->insert("0.0", $content);
        } else {
            print "TODO: Report error $! for '$filename'\n";
        }
    }
}


sub run_tidy {
    my ($self) = @_;

    my $rc = '';
    for my $field (sort keys %config) {
        if (defined $config{$field}) {
            $rc .= "$field=$config{$field}\n";
        } else {
            $rc .= "$field\n";
        }
    }

    my $code = $self->{text}->get("0.0", 'end');
    my $clean;
    my $stderr;

    my $error = Perl::Tidy::perltidy(
        source      => \$code,
        destination => \$clean,
        stderr      => \$stderr,
        perltidyrc  => \$rc,
    );
    $self->{text}->delete("0.0", 'end');
    $self->{text}->insert("0.0", $clean);
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
