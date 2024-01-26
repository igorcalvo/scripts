# Enter script code
#exit insert mode
keyboard.press_key('<esc>')
keyboard.release_key('<esc>')

#:
keyboard.press_key('<shift>')
keyboard.press_key(';')
keyboard.release_key(';')
keyboard.release_key('<shift>')

#save
keyboard.press_key('w')
keyboard.release_key('w')
keyboard.press_key('<enter>')
keyboard.release_key('<enter>')

#switch terminal
keyboard.press_key('<ctrl>')
keyboard.fake_keypress('<tab>')
keyboard.release_key('<ctrl>')

#run latest command
keyboard.fake_keypress('<up>')
keyboard.fake_keypress('<enter>')

#go back to editor
keyboard.press_key('<ctrl>')
keyboard.press_key('<shift>')
keyboard.fake_keypress('<tab>')
keyboard.release_key('<shift>')
keyboard.release_key('<ctrl>')

