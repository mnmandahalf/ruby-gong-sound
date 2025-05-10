# Ruby Gong Sound

A Ruby script for generating gong sounds and timers.
This program creates synthesized gong (tam-tam) sounds and includes a simple timer functionality.

## Features

- Generates gong sounds that mimic physical acoustic properties
- Timer functionality that notifies with a gong sound when time is up
- Sound saving in WAV format
- Countdown feedback every 10 seconds
- Support for both English (default) and Japanese languages

## Requirements

- Ruby 2.6 or higher
- Required gems:
  - wavefile

## Installation

```bash
git clone https://github.com/your-username/ruby-gong-sound.git
cd ruby-gong-sound
bundle install
```

## Usage

### Playing the Gong Sound

```bash
ruby gong.rb
```

### Timer Mode

Set a timer for a specified number of minutes (default is 5 minutes):

```bash
ruby gong.rb --timer 10  # Set a 10-minute timer (English)
# or
ruby gong.rb -t 10
```

### Language Options

Use Japanese language for timer messages:

```bash
ruby gong.rb --timer 10 --ja  # Japanese messages
# or
ruby gong.rb -t 10 -j
```

Use English language explicitly (this is the default):

```bash
ruby gong.rb --timer 10 --en  # English messages
# or
ruby gong.rb -t 10 -e
```

## How It Works

This program generates gong-like sounds by combining multiple harmonic frequencies with decay envelopes. The timbre can be customized by adjusting the parameters in the code.
