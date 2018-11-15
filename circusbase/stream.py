# coding:utf-8
"""
An option for streaming circus stdout that uses emoji
"""
from datetime import datetime
import sys

from circus.stream import StdoutStream
from circus.py3compat import s

from codado import remoji


class EmojiStdoutStream(StdoutStream):
    """
    Write output from watchers using a random 2-emoji prefix (repeated, for a total of 4 characters) to distinguish processes in the circus output.
    Here is an example: ::
      [watcher:foo]
      cmd = python -m myapp.server
      stdout_stream.class = EmojiStdoutStream
      stdout_stream.time_format = '%Y/%m/%d | %H:%M:%S'
    """
    @property
    def out(self):
        """
        Where we write output

        We upgrade it to a utf-8 writer for python 3
        """
        if not hasattr(self, '_out'): # pragma: nocover
            self._out = sys.stdout
        return self._out

    # Generate a datetime object
    now = datetime.now
    fromtimestamp = datetime.fromtimestamp

    def __init__(self, time_format=None, **kwargs):
        super(EmojiStdoutStream, self).__init__(**kwargs)
        self.time_format = time_format or '%Y-%m-%d %H:%M:%S'
        self.emoji_tag = (remoji() + u' ' + remoji() + u' ')

    def prefix(self, data):
        """
        Create a prefix for each line.
        """
        pid = data['pid']
        if 'timestamp' in data:
            time = self.fromtimestamp(data['timestamp'])
        else:
            time = self.now()
        time = time.strftime(self.time_format)

        prefix = '{time} [{pid}] {emoji} | '.format(emoji=self.emoji_tag, pid=pid, time=time)
        return prefix

    def __call__(self, data):
        for line in s(data['data']).split('\n'):
            if line:
                self.out.write(self.prefix(data))
                self.out.write(line + '\n')
                self.out.flush()
