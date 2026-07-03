import sys

def resolve(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    resolved_lines = []
    in_conflict = False
    
    for line in lines:
        if line.startswith('<<<<<<< HEAD'):
            in_conflict = True
        elif line.startswith('======='):
            pass
        elif line.startswith('>>>>>>>'):
            in_conflict = False
        else:
            resolved_lines.append(line)
            
    with open(file_path, 'w') as f:
        f.writelines(resolved_lines)

resolve('Shopify.xcodeproj/project.pbxproj')
resolve('.gitignore')
resolve('Shopify.xcworkspace/contents.xcworkspacedata')
