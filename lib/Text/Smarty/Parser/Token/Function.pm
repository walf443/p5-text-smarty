package  Text::Smarty::Parser::Token::Function;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub name { $_[0]->{name} }

1;
