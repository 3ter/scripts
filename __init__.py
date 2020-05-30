# License AGPLv3

from aqt.editor import Editor
from anki.utils import json
from anki.hooks import addHook

# For debugging purposes just add something like 'sys.stderr.write(f"{html}\n")' to get the info when running the app
# it's opening an infobox with all the information
# import sys

import re

def wrap_selection_in_html(editor, before, after):
    text = editor.web.selectedText()

    # use the json.dumps function on the arguments and the selected text
    # and make sure it's inseted as html (and not plain text) like with shift+ctrl+x
    html = f"setFormat('inserthtml', {json.dumps(before + text + after)});"

    # Remove \u00a0 in case you've selected the beginning
    p = re.compile('(\\u00a0)')
    p.sub('', html)

    editor.web.eval(html)

def setupEditorButtonsFilter(buttons, editor):
    html_before = '<code class="inline">'
    html_after  = '</code>'
    buttontext  = 'ic'
    shortcut    = 'Ctrl+Alt+9'
    tooltip     = f"render selected text as inline code {shortcut}"

    buttons.append(editor.addButton(
        icon=None,
        cmd="wrap_inline_code",
        func=lambda editor: wrap_selection_in_html(editor, '<code class="inline">', '</code>'),
        tip=tooltip,
        label=buttontext,
        keys=shortcut
        )
    )

    html_before = '<kbd>'
    html_after  = '</kbd>'
    buttontext  = 'kb'
    shortcut    = 'Ctrl+Alt+8'
    tooltip     = f"render selected text as keyboard keys {shortcut}"

    buttons.append(editor.addButton(
        icon=None,
        cmd="wrap_kbd",
        func=lambda editor: wrap_selection_in_html(editor, '<kbd>', '</kbd>'),
        tip=tooltip,
        label=buttontext,
        keys=shortcut
        )
    )

    return buttons

addHook("setupEditorButtons", setupEditorButtonsFilter)
