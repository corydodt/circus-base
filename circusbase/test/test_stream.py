"""
Test the stream module

Does it provide an interface compatible with circus?
"""
from calendar import timegm
from io import StringIO

from pytest import fixture

from mock import patch

from codado import parseDate, py

from circusbase import stream


@fixture
def stdoutStream(pRemoji):
    ret = stream.EmojiStdoutStream()
    ret._out = StringIO()
    return ret


@fixture
def pRemoji():
    """
    A function that returns "random" choices
    """
    with patch.object(stream, 'remoji', side_effect=[py.EMOJI[2], py.EMOJI[4]]):
        yield


def test_stream(stdoutStream):
    """
    Does it add the prefix before writing?
    """
    _1109 = parseDate('2018-11-09 11:11:11-0800')
    data = {
        'data': 'hello dolly',
        'pid': 999,
        'timestamp': timegm(_1109.timetuple())
    }
    stdoutStream(data)
    # fyi there's a change in the timezone due to our use of timegm,
    # and we don't account for it here.
    expected = '2018-11-09 03:11:11 [999] 🤖 💫  | hello dolly\n'
    assert stdoutStream.out.getvalue() == expected
    stdoutStream.out.truncate(0)
    stdoutStream.out.seek(0)

    data2 = data.copy()
    del data2['timestamp']
    with patch.object(stdoutStream, 'now', return_value=_1109):
        stdoutStream(data2)
    expected = '2018-11-09 11:11:11 [999] 🤖 💫  | hello dolly\n'
    assert stdoutStream.out.getvalue() == expected
