package  Text::Smarty::Parser::Token::IF;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub cond { $_[0]->{cond} }

1;
