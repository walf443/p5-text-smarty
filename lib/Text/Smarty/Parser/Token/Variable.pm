package  Text::Smarty::Parser::Token::Variable;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub name { $_[0]->{name} };

1;
