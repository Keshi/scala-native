object SetWritableTest {
  import Files._
  import scala.scalanative.runtime.Platform
  def main(args: Array[String]): Unit = if (!Platform.isWindows) {
    assert(willBeSetWritableFile.exists())
    assert(!willBeSetWritableFile.canExecute())
    assert(!willBeSetWritableFile.canRead())
    assert(!willBeSetWritableFile.canWrite())

    assert(willBeSetWritableFile.setWritable(true))
    assert(!willBeSetWritableFile.canExecute())
    assert(!willBeSetWritableFile.canRead())
    assert(willBeSetWritableFile.canWrite())

    assert(willBeSetWritableFile.setWritable(false))
    assert(!willBeSetWritableFile.canExecute())
    assert(!willBeSetWritableFile.canRead())
    assert(!willBeSetWritableFile.canWrite())

    assert(willBeSetWritableDirectory.exists())
    assert(!willBeSetWritableDirectory.canExecute())
    assert(!willBeSetWritableDirectory.canRead())
    assert(!willBeSetWritableDirectory.canWrite())

    assert(willBeSetWritableDirectory.setWritable(true))
    assert(!willBeSetWritableDirectory.canExecute())
    assert(!willBeSetWritableDirectory.canRead())
    assert(willBeSetWritableDirectory.canWrite())

    assert(willBeSetWritableDirectory.setWritable(false))
    assert(!willBeSetWritableDirectory.canExecute())
    assert(!willBeSetWritableDirectory.canRead())
    assert(!willBeSetWritableDirectory.canWrite())

    assert(!nonexistentFile.exists)
    assert(!nonexistentFile.setWritable(true))

  }
}
