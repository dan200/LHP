# LHP
LHP ("Lua Hypertext Processor") is an ultra minimal parser for embedding Lua code inline with text files, in the style of PHP. It was created for static website generation, but could in principal be used dyamically within a web server, or for any text generation task.

## Example usage
Input file:
```
<!DOCTYPE HTML>
<html>   
    <body>
      <h1>The Fibionacci sequence:</h1>
      <ul>
        <?lua
          -- Print the first ten digits of the fibonacci sequence
          local a,b = 0,1
          for n=1,10 do
            echo( "<li>" .. a .. "</li> )
            local sum = a + b              
            a = b
            b = sum
          end
        ?>
      </ul>
    </body>
</html>
```

Compiling:
```
lua lhp.lua input.lhp output.html
```

Output file:
```
<!DOCTYPE HTML>
<html>   
    <body>
      <h1>The Fibionacci sequence:</h1>
      <ul>
        <li>0</li>
        <li>1</li>
        <li>1</li>
        <li>2</li>
        <li>3</li>
        <li>5</li>
        <li>8</li>
        <li>13</li>
        <li>21</li>
        <li>34</li>
      </ul>
    </body>
</html>
