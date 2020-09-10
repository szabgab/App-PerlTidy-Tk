package App::PerlTidy::Tk;
use strict;
use warnings;
use 5.008;

use Tk;

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
    $about_menu->command(-label => 'About', -command => \&about);

    $self->{top}->configure(-menu => $main_menu);
}

sub show_open {
    my ($self) = @_;

    print("open\n");
}

sub run_tidy {
    my ($self) = @_;

    print("run\n");
}

sub about {
    my ($self) = @_;

    print("about\n");
}

sub exit_app {
    my ($self) = @_;

    print("exit\n");
    exit;
}

1;
