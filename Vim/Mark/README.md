# Mark `m`

## 设置标记

- `m + [a-zA-Z]`:
	- 比如 `ma` 就是 把光标当前位置标记为 `a`

## 跳转到标记位置

- `' + 标记字母`
	- 这里的 `标记字母` 就是上面的 `[a-zA-Z]`, 你之前用哪个字母做的标记，现在就用 `'` 加上那个字母跳过去

### 大小写的区别

- 那么只能在当前文档跳转到小写标记的位置
- 大写标记的位置，无论你现在在哪个文档，都能跳转到

### map

#### Idea && Vim

- idea 放到 `~/.ideavimrc`
- vim 放到对应的配置文件里， 一般是 `~/.vimrc`; nvim 一般是 `~/.config/nvim/init.vim`
```
nnoremap ma mA
nnoremap 'a 'A
nnoremap ms mS
nnoremap 's 'S
nnoremap md mD
nnoremap 'd 'D
```

#### Vscode

- 放到 `settings.json` 文件的 `{"vim.normalModeKeyBindings": [ 这里 ]}` 

```
{
		"before": [
				"m", "a"
		], "after": ["m", "A"]
},
{
		"before": [
				"'", "a"
		], "after": ["'", "A"]
},
{
		"before": [
				"m", "s"
		], "after": ["m", "S"]
},
{
		"before": [
				"'", "s"
		], "after": ["'", "S"]
},
{
		"before": [
				"m", "d"
		], "after": ["m", "D"]
},
{
		"before": [
				"'", "d"
		], "after": ["'", "D"]
}
```