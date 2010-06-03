package  Text::Smarty::Parser::Token::Function;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub name { $_[0]->{name} }

sub args_file { $_[0]->{args}->{file} }

sub args_from { $_[0]->{args}->{from} }

sub args_item { $_[0]->{args}->{item} }

1;
