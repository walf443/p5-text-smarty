package  Text::Smarty::Parser::Token;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

1;
