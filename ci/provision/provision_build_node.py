"""Provisions a build VM from a config file

"""

import argparse
import shutil
import os

def copyfile(src, dest):
    """Copy a File"""
    try:
        shutil.copy(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print 'Error: %s' % e
        raise
    # eg. source or destination doesn't exist
    except IOError as e:
        print 'Error: %s' % e.strerror
        raise

class VagrantProvider(object):
    """ Vagrant provider class """
    def __init__(self, cfg):
        import tempfile
        self._parse_cfg(cfg)
        self.working_dir = tempfile.mkdtemp()
        copyfile(self.vagrant_file, self.working_dir+'/Vagrantfile')

    def _parse_cfg(self, cfg):
        self.vagrant_file = cfg['vagrant_file']

    def start(self):
        import vagrant
        print 'Changing directory to %s' % self.working_dir
        os.chdir(self.working_dir)
        v = vagrant.Vagrant()
        v.up()

def read_config(filename):
    """Reads a YAML formatted config file"""
    import yaml
    cfg = open(filename, 'r')
    return yaml.load(cfg)

def get_provider(cfg):
    """ Factory function for getting a instance of the provider """
    print cfg
    if cfg['provider'].lower() == 'vagrant':
        return VagrantProvider(cfg)
    else:
        raise "Unknown provider type %s" % cfg['provider']


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Provision a build VM')
    parser.add_argument("-f", "--config_file", type=str,
                    help='Configuration file location', required=True)

    args = parser.parse_args()

    print "Reading configuration from %s" % args.config_file
    config = read_config(args.config_file)

    provider = get_provider(config)
    provider.start()

