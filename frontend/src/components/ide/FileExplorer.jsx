import { useState, useRef, useEffect } from 'react'

const FILE_COLORS = {
  c: '#519aba', h: '#519aba', cpp: '#519aba', cc: '#519aba',
  py: '#3572A5', java: '#b07219', js: '#f1e05a', jsx: '#61dafb',
  sql: '#e38c00', md: '#083fa1', txt: '#888', sh: '#89e051',
}

function getExt(name) {
  return (name.split('.').pop() || '').toLowerCase()
}

export default function FileExplorer({ files, activeFile, onSelect, onCreate, onDelete, onRename, projectName = 'PROJECT' }) {
  const [creating, setCreating] = useState(false)
  const [newName, setNewName] = useState('')
  const [renaming, setRenaming] = useState(null)
  const [renameVal, setRenameVal] = useState('')
  const createRef = useRef(null)
  const renameRef = useRef(null)

  useEffect(() => { if (creating) createRef.current?.focus() }, [creating])
  useEffect(() => { if (renaming) renameRef.current?.focus() }, [renaming])

  const handleCreate = () => {
    const name = newName.trim()
    if (name && !files[name]) { onCreate(name); setNewName(''); setCreating(false) }
    else { setCreating(false); setNewName('') }
  }

  const handleRename = (oldName) => {
    const name = renameVal.trim()
    if (name && name !== oldName && !files[name]) onRename(oldName, name)
    setRenaming(null); setRenameVal('')
  }

  const fileNames = Object.keys(files).sort()

  return (
    <div className="h-full flex flex-col select-none" style={{ background: '#252526', color: '#cccccc', fontSize: '13px' }}>
      {/* Section header */}
      <div className="flex items-center justify-between px-2 py-1.5" style={{ background: '#252526', borderBottom: '1px solid #3c3c3c' }}>
        <span className="text-[11px] uppercase tracking-wider font-semibold text-[#bbb]">Explorer</span>
        <div className="flex items-center gap-0.5">
          <button onClick={() => setCreating(true)} className="p-1 rounded hover:bg-[#3c3c3c] text-[#ccc] hover:text-white" title="New File">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
              <path d="M12 3H8.5L7.5 2H4c-.6 0-1 .4-1 1v10c0 .6.4 1 1 1h8c.6 0 1-.4 1-1V4c0-.6-.4-1-1-1zm0 10H4V3h3l1 1h4v9z"/>
              <path d="M9 6H7v2H5v2h2v2h2v-2h2V8H9V6z"/>
            </svg>
          </button>
        </div>
      </div>

      {/* Project folder header */}
      <div className="flex items-center gap-1.5 px-2 py-1" style={{ background: '#2a2d2e' }}>
        <span className="text-[10px] text-[#ccc]">▾</span>
        <svg width="14" height="14" viewBox="0 0 16 16" fill="#dcb67a"><path d="M14.5 3H7.71l-.85-.85L6.51 2h-5l-.5.5v11l.5.5h13l.5-.5v-10L14.5 3zm-.51 8.49V13H2V3h4.29l.85.85.36.15H14v7.49z"/></svg>
        <span className="text-[12px] font-semibold text-[#ccc] uppercase">{projectName}</span>
      </div>

      {/* File list */}
      <div className="flex-1 overflow-y-auto" style={{ scrollbarWidth: 'thin' }}>
        {fileNames.map(name => (
          <div key={name}>
            {renaming === name ? (
              <div className="px-5 py-0.5">
                <input ref={renameRef} value={renameVal} onChange={e => setRenameVal(e.target.value)}
                  onKeyDown={e => { if (e.key === 'Enter') handleRename(name); if (e.key === 'Escape') { setRenaming(null); setRenameVal('') } }}
                  onBlur={() => handleRename(name)}
                  className="w-full px-1 py-0.5 text-[13px] font-mono outline-none rounded-sm"
                  style={{ background: '#3c3c3c', color: '#fff', border: '1px solid #007acc' }}
                />
              </div>
            ) : (
              <div
                onClick={() => onSelect(name)}
                onDoubleClick={() => { setRenaming(name); setRenameVal(name) }}
                className="group flex items-center justify-between cursor-pointer"
                style={{
                  padding: '2px 8px 2px 24px',
                  background: activeFile === name ? '#37373d' : 'transparent',
                }}
                onMouseEnter={e => { if (activeFile !== name) e.currentTarget.style.background = '#2a2d2e' }}
                onMouseLeave={e => { if (activeFile !== name) e.currentTarget.style.background = 'transparent' }}
              >
                <div className="flex items-center gap-1.5 min-w-0">
                  <span className="w-4 h-4 flex items-center justify-center flex-shrink-0 text-[9px] font-bold rounded-sm"
                    style={{ color: FILE_COLORS[getExt(name)] || '#888' }}>
                    {getExt(name) === 'py' ? '🐍' : getExt(name) === 'java' ? '☕' : getExt(name) === 'c' || getExt(name) === 'cpp' || getExt(name) === 'h' ? 'C' : '📄'}
                  </span>
                  <span className="truncate" style={{ color: activeFile === name ? '#fff' : '#ccc' }}>{name}</span>
                </div>
                <button
                  onClick={e => { e.stopPropagation(); if (confirm(`Delete "${name}"?`)) onDelete(name) }}
                  className="opacity-0 group-hover:opacity-100 p-0.5 rounded transition-opacity"
                  style={{ color: '#888' }}
                  onMouseEnter={e => e.currentTarget.style.color = '#fff'}
                  onMouseLeave={e => e.currentTarget.style.color = '#888'}
                  title="Delete"
                >
                  ✕
                </button>
              </div>
            )}
          </div>
        ))}

        {/* New file input */}
        {creating && (
          <div className="px-5 py-0.5">
            <input ref={createRef} value={newName} onChange={e => setNewName(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter') handleCreate(); if (e.key === 'Escape') { setCreating(false); setNewName('') } }}
              onBlur={() => { if (newName.trim()) handleCreate(); else { setCreating(false); setNewName('') } }}
              placeholder="filename.ext"
              className="w-full px-1 py-0.5 text-[13px] font-mono outline-none rounded-sm"
              style={{ background: '#3c3c3c', color: '#fff', border: '1px solid #007acc' }}
            />
          </div>
        )}
      </div>
    </div>
  )
}
