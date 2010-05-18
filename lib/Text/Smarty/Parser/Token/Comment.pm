package  Text::Smarty::Parser::Token::Comment;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub comment { $_[0]->{comment} }

1;
