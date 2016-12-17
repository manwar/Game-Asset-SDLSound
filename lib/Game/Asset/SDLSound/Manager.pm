# Copyright (c) 2016  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
package Game::Asset::SDLSound::Manager;

use strict;
use warnings;
use Moose;
use namespace::autoclean;
use SDL ();
use SDL::Mixer ();
use SDL::Mixer::Music ();

has '_is_init_done' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);
has 'freq' => (
    is => 'ro',
    isa => 'Int',
    default => 44_100,
);
has 'format' => (
    is => 'ro',
    default => SDL::Mixer::MIX_DEFAULT_FORMAT,
);
has 'channels' => (
    is => 'ro',
    isa => 'Int',
    default => 2,
);
has 'chunksize' => (
    is => 'ro',
    isa => 'Int',
    default => 4096,
);


sub init
{
    my ($self) = @_;
    return if $self->_is_init_done;

    SDL::init( SDL::SDL_INIT_AUDIO );
    SDL::Mixer::init(
        SDL::Mixer::MIX_INIT_FLAC
        | SDL::Mixer::MIX_INIT_MOD
        | SDL::Mixer::MIX_INIT_MP3
        | SDL::Mixer::MIX_INIT_OGG
    );

    SDL::Mixer::open_audio( 
        $self->freq,
        $self->format,
        $self->channels,
        $self->chunksize,
    );

    $self->_is_init_done( 1 );
    return;
}

sub finish
{
    my ($self) = @_;
    SDL::Mixer::quit;
    $self->_is_init_done( 0 );
    return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

